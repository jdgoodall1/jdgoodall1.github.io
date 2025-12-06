# PowerShell script to validate Jekyll configuration for GitHub Pages compatibility
# Feature: jekyll-site-modernization, Property 14: GitHub Pages plugin compatibility
# Validates: Requirements 6.1

$ErrorActionPreference = "Stop"

# GitHub Pages supported plugins whitelist
$GITHUB_PAGES_PLUGINS = @(
    'jekyll-coffeescript',
    'jekyll-commonmark-ghpages',
    'jekyll-gist',
    'jekyll-github-metadata',
    'jekyll-paginate',
    'jekyll-relative-links',
    'jekyll-optional-front-matter',
    'jekyll-readme-index',
    'jekyll-default-layout',
    'jekyll-titles-from-headings',
    'jekyll-feed',
    'jekyll-seo-tag',
    'jekyll-sitemap',
    'jekyll-avatar',
    'jekyll-mentions',
    'jekyll-redirect-from',
    'jekyll-remote-theme',
    'jekyll-include-cache',
    'jemoji'
)

function Test-GitHubPagesCompatibility {
    $configFile = "_config.yml"
    
    # Check if config file exists
    if (-not (Test-Path $configFile)) {
        Write-Host "[FAIL] ERROR: $configFile does not exist" -ForegroundColor Red
        return $false
    }
    
    # Read and parse YAML (simple parsing for plugins section)
    $content = Get-Content $configFile -Raw
    
    # Extract plugins section - look for lines that start with "  - " after "plugins:"
    $lines = $content -split '\n'
    $inPluginsSection = $false
    $plugins = @()
    
    foreach ($line in $lines) {
        if ($line -match '^plugins:\s*$') {
            $inPluginsSection = $true
            continue
        }
        
        if ($inPluginsSection) {
            # Check if this is a plugin line (starts with "  - ")
            if ($line -match '^\s{2}-\s+(.+?)\s*$') {
                $plugins += $matches[1]
            }
            # If we hit a line that doesn't start with "  - " and isn't empty, we're done
            elseif ($line -match '^\S' -and $line.Trim() -ne '') {
                break
            }
        }
    }
    
    if ($plugins.Count -gt 0) {
        
        Write-Host ""
        Write-Host "Validating GitHub Pages Plugin Compatibility..." -ForegroundColor Cyan
        Write-Host "Found $($plugins.Count) plugins in configuration" -ForegroundColor Gray
        Write-Host ""
        
        # Check for duplicates
        $uniquePlugins = $plugins | Select-Object -Unique
        if ($plugins.Count -ne $uniquePlugins.Count) {
            $duplicates = $plugins | Group-Object | Where-Object { $_.Count -gt 1 } | Select-Object -ExpandProperty Name
            Write-Host "[FAIL] ERROR: Duplicate plugins found: $($duplicates -join ', ')" -ForegroundColor Red
            return $false
        }
        
        # Validate each plugin is in whitelist
        $invalidPlugins = @()
        foreach ($plugin in $plugins) {
            if ($plugin -notin $GITHUB_PAGES_PLUGINS) {
                $invalidPlugins += $plugin
            }
        }
        
        if ($invalidPlugins.Count -gt 0) {
            Write-Host "[FAIL] ERROR: The following plugins are NOT supported by GitHub Pages:" -ForegroundColor Red
            foreach ($p in $invalidPlugins) {
                Write-Host "  - $p" -ForegroundColor Red
            }
            Write-Host ""
            Write-Host "Supported plugins:" -ForegroundColor Yellow
            foreach ($p in $GITHUB_PAGES_PLUGINS) {
                Write-Host "  - $p" -ForegroundColor Gray
            }
            return $false
        }
        
        # Check required plugins
        $requiredPlugins = @('jekyll-feed', 'jekyll-seo-tag', 'jekyll-sitemap', 'jekyll-paginate')
        $missingPlugins = $requiredPlugins | Where-Object { $_ -notin $plugins }
        
        if ($missingPlugins.Count -gt 0) {
            Write-Host "[FAIL] ERROR: Missing required plugins: $($missingPlugins -join ', ')" -ForegroundColor Red
            return $false
        }
        
        # All validations passed
        Write-Host "[PASS] All plugins are GitHub Pages compatible!" -ForegroundColor Green
        Write-Host "[PASS] Configured plugins: $($plugins -join ', ')" -ForegroundColor Green
        Write-Host "[PASS] All required plugins are present" -ForegroundColor Green
        Write-Host "[PASS] No duplicate plugins found" -ForegroundColor Green
        Write-Host ""
        Write-Host "[PASS] Property 14 validated: GitHub Pages plugin compatibility" -ForegroundColor Green
        Write-Host "       Validates: Requirements 6.1" -ForegroundColor Gray
        Write-Host ""
        
        return $true
    }
    else {
        Write-Host "[FAIL] ERROR: Could not find 'plugins:' section in $configFile or no plugins configured" -ForegroundColor Red
        return $false
    }
}

# Run the validation
$result = Test-GitHubPagesCompatibility

if ($result) {
    Write-Host "[PASS] VALIDATION PASSED" -ForegroundColor Green
    exit 0
}
else {
    Write-Host ""
    Write-Host "[FAIL] VALIDATION FAILED" -ForegroundColor Red
    exit 1
}
