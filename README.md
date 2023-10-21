# Setup Python Build GitHub Action

This actions is designed to prepare Python and Poetry for subsequent actions.
This actions tries to respect settings that might be provided by `poetry.toml`,
so it checks where the virtualenv is located based on that.

It also tries to cache as much as possible, so poetry installation is cached
as well as the virtualenv.

## Typical usage in Poetry project

```yaml
steps:
  - name: Checkout repository
    uses: actions/checkout@v3
  - name: Setup python
    uses: martin-macak/github-action-setup-python-build@main
    with:
      python-version: 3.10
      poetry-version: 1.1.5
  - name: Build
    #language=bash
    run: |
      poetry build
  - name: Test
    #language=bash
    run: |
      poetry install
      poetry run pytest tests
```
