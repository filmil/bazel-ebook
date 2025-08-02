# Publish to Bazel central registry

Ensure that the repository is clean without uncommitted changes and with an
empty index.

In file `MODULE.bazel` increment the `version` SemVer parameter value in the
`module` statement as follows:

* Note the current value of the parameter `version` in statement `module` in the
  file `MODULE.bazel.`

    * If the short descriptions of the git changes from since the commit tag equal
      to the current value of `version` contains a prefix `BREAKING:`, increment
      the major SemVer version number, set minor and patch both to zero.
    * Otherwise if in the same range of commits there are `feat:` descriptions,
      increment the minor version number and set patch to zero.
    * Otherwise increment the patch version number only.

* Modify parameter `version` in the statement `module` in file MODULE.bazel` to
  the newly computed version number.

* Create a commit for this change. If able use the `gh` command line utility
  to create a pull request.

* Tag this commit with the value of `version` previously computed. Push that tag
  to the remote repository.

