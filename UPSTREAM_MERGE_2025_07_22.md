# Upstream Merge Report - July 22, 2025

## Summary

This report documents the attempt to merge upstream changes from space-wizards/space-station-14 into the Liminality-Project fork.

## Challenge Analysis

### Repository Relationship
- Liminality-Project is a fork of Delta-V, which itself is a fork of Space Station 14
- The repositories have completely unrelated git histories (no common ancestor)
- Last upstream merge was February 12, 2025
- **3,258 commits** have been added to upstream since the last merge
- A full merge attempt resulted in **5,777 conflicted files**

### Technical Challenges
1. **Unrelated Histories**: Git merge requires `--allow-unrelated-histories` flag
2. **Massive Conflicts**: Nearly every file conflicts between upstream and fork
3. **Functional Divergence**: Fork contains significant Delta-V specific functionality
4. **Build Dependencies**: RobustToolbox submodule version differences cause build issues
5. **Package Dependencies**: NuGet feed connectivity issues during build validation

## Approach Taken

### Selective Cherry-Picking Strategy
Instead of a full merge, we adopted a selective cherry-picking approach:

**Successfully Applied:**
- `2b2b9b11b8`: Fix #38935: Remove empty EnsnaringComponent.cs file
- `65b4b41928`: Fix RoundEndTest obsolete warnings

**Attempted but Skipped:**
- `f16175a6e3`: SSD indicator improvements (conflicts with fork functionality)
- `ed6ed6c5f3`: Sleep system build fix (conflicts with fork's stun handling)

## Recommendations

### 1. Structured Selective Merging
Continue with targeted cherry-picking approach:
- Focus on security fixes and critical bug fixes
- Avoid feature additions that conflict with Delta-V/Liminality functionality
- Test each cherry-pick individually

### 2. Categories for Future Merges
- **High Priority**: Security fixes, critical bug fixes, build system improvements
- **Medium Priority**: Performance improvements, minor bug fixes
- **Low Priority**: New features (evaluate case-by-case for conflicts)

### 3. Build System Coordination
- RobustToolbox updates require careful coordination
- Consider updating in separate PRs with full testing
- Ensure .NET SDK compatibility (currently requires 9.0.100)

### 4. Regular Maintenance Schedule
- Perform selective merges monthly rather than large quarterly merges
- Maintain a list of upstream commits to evaluate
- Document any fork-specific modifications that prevent clean merges

## Technical Notes

### Build Environment
- Requires .NET SDK 9.0.100
- RobustToolbox submodule at commit `da2bfdaa1068eb7c7383ee2e064102ffc0f4303a`
- NuGet feeds may have connectivity issues in CI environments

### File Conflict Patterns
Most conflicts occur in:
- Core game systems (player, movement, health)
- UI components and interfaces
- Game balance and configuration files
- GitHub workflow files

## Conclusion

A full upstream merge is not practical due to the scale of divergence between the fork and upstream. The selective cherry-picking approach allows incorporation of critical fixes while preserving fork-specific functionality. This strategy should continue for future upstream synchronization efforts.

## Next Steps

1. Test build with current changes
2. Identify additional low-risk cherry-pick candidates
3. Document process for future maintenance
4. Consider automation for identifying cherry-pick candidates