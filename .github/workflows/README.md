# GitHub Actions Environment Setup

This document describes the configuration changes made to solve firewall issues in GitHub Actions workflows.

## Problem Statement

The GitHub Actions runners were experiencing firewall blocks when trying to access Microsoft package feeds during `dotnet restore` operations. Specifically, connections to `mfjvsblobprodcus373.vsblob.vsassets.io` were being blocked, causing build failures.

## Solution

All .NET workflows have been updated with the following improvements:

### 1. NuGet Package Caching

Added `actions/cache@v3` to cache NuGet packages between workflow runs:
- Uses unique cache keys per workflow type and OS
- Reduces dependency on external package feeds
- Improves build performance and reliability

### 2. Pre-download Strategy

Added a "Pre-download NuGet packages (before firewall)" step that:
- Runs immediately after .NET setup but before firewall restrictions activate
- Downloads all required packages to the local cache
- Configures dotnet to reduce external calls (`DOTNET_CLI_TELEMETRY_OPTOUT=1`)

### 3. Offline-friendly Configuration

- Disabled .NET CLI telemetry to reduce external connections
- Set `DOTNET_SKIP_FIRST_TIME_EXPERIENCE=1` to avoid first-time setup calls
- Used `--verbosity minimal` to reduce logging overhead

## Affected Workflows

The following workflows have been updated:

1. **build-test-debug.yml** - Main build and test workflow
2. **publish.yml** - Package publication workflow  
3. **test-packaging.yml** - Packaging verification workflow
4. **build-docfx.yml** - Documentation build workflow
5. **yaml-linter.yml** - YAML validation workflow
6. **build-map-renderer.yml** - Map renderer build workflow

## Technical Details

### Cache Strategy

Each workflow uses a unique cache key pattern:
```yaml
key: ${{ runner.os }}-nuget-{workflow}-${{ hashFiles('**/*.csproj', '**/*.fsproj', '**/*.vbproj') }}
```

This ensures:
- Cache invalidation when project files change
- Workflow-specific caches to avoid conflicts
- OS-specific caching for matrix builds

### Fallback Strategy

The cache configuration includes fallback keys:
```yaml
restore-keys: |
  ${{ runner.os }}-nuget-{workflow}-
  ${{ runner.os }}-nuget-
```

This allows workflows to share cached packages when appropriate while maintaining isolation.

## Benefits

1. **Firewall Resilience**: Pre-downloading packages before firewall activation
2. **Performance**: Cached packages reduce download time in subsequent runs
3. **Reliability**: Reduced dependency on external package feed availability
4. **Maintainability**: Consistent pattern across all workflows

## Testing

These changes have been applied to all .NET workflows and should resolve the firewall connectivity issues that were blocking builds. The caching strategy also provides a performance improvement for subsequent workflow runs.

## Monitoring

Monitor workflow runs for:
- Successful package downloads in the pre-download step
- Cache hit/miss rates in the cache step
- Overall build time improvements
- Absence of firewall-related failures