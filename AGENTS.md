# Agent instructions

NichtImKopf Web Community (`nik_web`) is a website builder for small craft businesses: pages are built from blocks, with what a workshop needs online, such as inquiry forms, bookings and configurators. It is a Frappe app for Frappe 16 and must install and run on a site without ERPNext. Frappe comes first: the app adds its own code only where the native way cannot do the job. The page builder is the stated exception: pages, blocks and forms are the app's own DocTypes. It does not build on Frappe's Web Page, Web Template or Web Form, and not on the app Frappe Builder. Frappe's website framework stays the base: the website generator, routing, the website cache and permissions.

## Before you write code

- Look for what already exists. Check how Frappe solves the problem: a DocType, a field, a setting, a hook, a report. Grep its source in the bench before you design anything.
- Read the official documentation of the mechanism you are about to use, and use it the way it describes. Do not build your own where a documented way exists.
- Learn how a feature is built from the features already in this repository, and build the next one the same way.

## Making the change

- Make the smallest correct change. Do not reformat, rename or move code you did not need to touch.
- Write code that needs no comment. Add one only where the code cannot say it itself: a reason that is not obvious, a limit, a workaround. No comments that narrate the change.
- What a tool can check becomes a check in `.pre-commit-config.yaml`, not a sentence in a file.
- Everything in this repository is English. German reaches the interface through Frappe's translations.

## Commands

- Checks: `pre-commit run --files <changed files>`.
- After changing a `uses:` line in a workflow: `gh actions-lock`, from the gh extension `github/gh-actions-lock`.
- Tests: `bench --site <site> run-tests --app nik_web`, or `--module <dotted.path>` for one module.
- Run tests on a throwaway site. Site names, ports and credentials belong to your machine and never to this repository.

## Pull requests

- Target `develop`. The title becomes the commit, so write it as one: `fix(page): keep the block order on copy`.
- The description says in a few plain sentences what the change is about, and in one line what was checked or that nothing was. No lists, tables or links.
- Commits and pull requests carry no AI attribution line.

## Never

- Never report something as tested, reproduced or checked that did not run.
- Never bypass permissions to make something work.
- Never write to the tables of Frappe or another app directly. Change their data through the document: `insert`, `save`, `delete`.
