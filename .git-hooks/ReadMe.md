# Git Hooks

Hooks in this directory are not executed by git for security reasons.

Check the content of executed scripts in **Operation/Repository.psm1**.

If you agree with what the scripts are doing, execute this command in the repo directory:

```cli
git config core.hooksPath .git-hooks
```

or the global version if all you repos use the same structure:

```cli
git config --global core.hooksPath .git-hooks
```
