This repository contains scripts used to achieve the dCache release process.

The scripts are:
    prepare-template      -- build a template file, used when updating release notes
    apply-template        -- apply edited template file to release-notes
    deploy-release-notes  -- build HTML (no longer necessary)
    tag-releases          -- tag releases
    update-releases       -- update the `releases.xml` file.
    binary-releases       -- use build machines to create packages.

The normal release procedure is:
    1. change directory to dCache repo,
    2. run `tag-releases` (triggers package building by CI),
    3. run `prepare-template` redirecting output as template file,
    4. change directory to release-notes repo,
    5. edit template file,
    6. run `apply-template`,
    7. wait for packages to finish building,
    8. run `update-releases`,
    9. check changes (e.g., `git diff`),
    10. commit and push changes to repo.

A binary-only release is when packages are made available without the
source-code being in github.  This is used when a vulnerability is
discovered, to provide an embargo period.  During the embargo period,
sites may upgrade without details of the vulnerability being
disclosed.

The binary-only release procedure is:
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
