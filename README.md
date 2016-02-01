This repository contains scripts used to achieve the dCache release process.

The scripts are:
    prepare-template      -- build a template file, used when updating release notes
    apply-template        -- apply edited template file to release-notes
    deploy-release-notes  -- build HTML (no longer necessary)
    tag-releases          -- tag releases
    update-releases       -- update the `releases.xml` file.

The procedure is:
    1. change directory to dCache repo
    2. run tag-releases      (triggering building of packages by CI)
    3. run prepare-template, redirecting output to release-notes repo
    4. change directory to release-notes repo
    5. edit template
    6. run apply-template
    7. wait for packages to build
    8. update-releases
    9. check changes, commit and push changes to repo
