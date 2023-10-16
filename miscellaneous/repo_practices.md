# Pull request og commit message practices

**Epostoversikt:**
- Simen Eidal <simeeid@stud.ntnu.no>
- Javid Rezai <javid.rezai@ntnu.no>
- Kasper Tyler Husefest <kasperth@stud.ntnu.no>
- Julie Lundberg Suter <julie.l.suter@ntnu.no>
- Olivia Foshaug Ingvaldsen <johain@stud.ntnu.no>
- Anton Hannibal Sökjer-Petersen <antonhs@stud.ntnu.no>

---

## File and folder structure for the webapp
- public/  - Keep static assets here
- redux/
  - slices/ - Redux data definitions go here
  - hooks.tsx
  - provider.tsx
  - store.tsx
- pages/ - contains page definitions
- components/  - contains the definitions for the components used by pages and/or other components
- styles/ - contains the application's styles. Can be imported with `import '@styles/filename.css'`
- logic/ - contains general logic detached from any one specific component, as well as other non-component files
- tests/ 
  - cypress - contains cypress-based tests
      - component/ - contains component tests
          - TestName.cy.tsx
      - integration/ - contains integration tests
          - TestName.cy.tsx
      - plugin/ - contains meta files
      - support/ - contains meta files
  - unit    - contains jest-based unit tests
      - TestName.test.tsx

## Commit messages
Commit messages are short and descriptive, and must be written with passive language. Normally, it's divided in three parts: the title, the body, and the footer. The title is a short overview of the changes the commit includes. For example, what changes have been made, or what has been done. The body elaborates on the details. One can mention what files or components have been changed, and what was changed in them. However, the body is not required in all circumstances. It's especially important if problems are encountered, and especially if the problems have influenced the solution in the commit. Essentially, if the reader benefits from more information to determine if a commit is good or not, the body should be used. It's also an opportunity to justify your changes before anyone asks, particularly if the solution isn't obviously intuitive.

The footer is especially important for backlog purposes. Here, you can  tag issues the changes belong to, and tag with co-authors. This is done like this:
```
Issue: #issue-nummer
Co-Authored-By: Name <email address>
```
See the list at the top of this page for an email list for the main people involved.
**Example**
```
Issue: #17
Co-Authored-By: Simen <simeeid@stud.ntnu.no>
```

It is not required to mention co-authors in the commit messages, but this signals that we have pair programmed or completed reviews.

## Branch names
When you make a new branch, it should be given a descriptive name containing why the branch was made, or what problems it's meant to solve. You do this by mentioning what changes have been made, in the format `change-type/description`. Some relevant change types include:

* `feat`: feature; something new has been added
* `ref`: refactor; change of an existing change
* `fix`: fixes to the code
* `chore`: extremely minor changes, such as grammatical corrections, or meta-changes, such as minor changes to the CI.

You may use other types if deemed necessary, but make sure it's  both properly defined, and doesn't overlap with anything else on this list. If you do end up using an undocumented type, please add it to this list, along with a definition.

The description should be short and concise, and should cover the primary objective of the branch. It doesn't need to be exhaustive; that's covered by commit messages and pull request messages.

**Example:** `feat/add-component-NavBar`

---

## Pull request

Similarly to commit messages, pull requests need a short and descriptive title, a body, and a footer.

Unlike commit messages, except for extremely short commits that don't require any more information than the title (such as fixing typos in documentation, or other changes that can be accurately described and understood from just the title), a descriptive body is always required. The body should include details about the fix, and any relevant problems or limitations encountered. This helps in future development by sharing potentially important information with other developers that may not have been directly involved in the development of any given PR.

And once again similarly to commit messages, the footer contains applicable issue links, and optionally a Co-Authored-By header. However, it's strongly recommended to use Co-Authored-By on a per-commit basis rather than including it in the PR, as PR messages are not part of the merge commit. This means the co-author information isn't directly part of the git history, meaning it isn't easy to get an overview of co-authors without manually sifting through PRs.

**Example:**
```
Closes #17
Co-Authored-By: Simen <simeeid@stud.ntnu.no>
```
