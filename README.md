This repository contains scripts used to achieve the dCache release process.
-----

### The scripts

- `prepare-template`      -- build a template file, used when updating release notes
- `apply-template`        -- apply edited template file to release-notes
- `deploy-release-notes`  -- build HTML (no longer necessary)
- `tag-releases`          -- tag releases
- `update-releases`       -- update the `releases.xml` file
- `binary-releases`       -- use build machines to create packages

### Normal bug-fix releases

Procedure:
1. change directory to dCache repo,
2. run `tag-releases` with a list of affected major versions (triggers package building by CI, wait for success),
3. run `prepare-template` with a list of affected major versions, redirecting output as template file,
4. change to `release-notes` repo,
5. edit template file,
6. run `apply-template`,
7. wait for packages to finish building,
8. run `update-releases` with a list of affected release versions (new tags),
9. check changes (e.g., `git diff`), commit and push changes to repo.

### Binary-only releases

A binary-only release is when packages are made available without the
source-code being in github. This is used when a vulnerability is
discovered, to provide an embargo period.  During the embargo period,
sites may upgrade without details of the vulnerability being
disclosed.

Procedure:
1. change directory to dCache repo,
2. apply patch(es) in support branch(es),
3. run `tag-releases --no-push` (no packages are built),
4. run `binary-releases` to build packages,
5. copy packages into package repo,
6. update release notes (manually),
7. run `update-releases`,
8. check changes, commit and push changes to repo,
9. wait for embargo period to finish,
10. copy packages from package repo,
11. push changes into github (triggers package building in CI),
12. copy packages from 10. back into package repo.
