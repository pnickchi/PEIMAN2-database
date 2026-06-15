# PEIMAN2-database

This repository stores and updates the external database files used by the
[`PEIMAN2`](https://cran.r-project.org/package=PEIMAN2) R package. The source
code for the PEIMAN2 package is available in the
[PEIMAN2 GitHub repository](https://github.com/pnickchi/PEIMAN2).

The purpose of this repository is to keep the PEIMAN2 database versions separate
from the CRAN package source code. This design helps keep the CRAN package small
and stable, while allowing users to download newer database versions when needed.

The PEIMAN2 package may still include a bundled database version for convenience
and CRAN-safe examples. I plan to update the bundled database periodically, for
example through annual CRAN submissions, but the most up-to-date database
versions will be maintained in this repository.


## Repository structure

```text
PEIMAN2-database/
├── databases/
│   ├── config.json                    # Database version log used by PEIMAN2
│   ├── peiman_database_YYYY-MM-DD.rds  # Versioned PEIMAN database files
│   └── ...
├── log/                               # Runtime logs from database update runs
├── src/                               # Source scripts used to build/update the database
├── arxiv/                             # Archived or older development files
├── main.R                             # Main script for updating the PEIMAN database
└── README.md
```

## Database files

Database files are stored in the `databases/` folder using the format:

```text
peiman_database_YYYY-MM-DD.rds
```

For example:

```text
peiman_database_2026-03-06.rds
```

Each file represents a frozen version of the PEIMAN database. This makes analyses
more reproducible because users can choose a specific database version instead
of always using the newest one.

## `databases/config.json`

The `databases/config.json` file lists all database versions available to the
PEIMAN2 package.

Example:

```json
[
  {
    "version": "2025-09-30",
    "file": "peiman_database_2025-09-30.rds",
    "url": "https://raw.githubusercontent.com/pnickchi/PEIMAN2-database/main/databases/peiman_database_2025-09-30.rds"
  },
  {
    "version": "2026-03-06",
    "file": "peiman_database_2026_03_06.rds",
    "url": "https://raw.githubusercontent.com/pnickchi/PEIMAN2-database/main/databases/peiman_database_2026-03-06.rds"
  }
]
```

The PEIMAN2 package reads this file through `update_peiman_database()` to find
available database versions and download the requested `.rds` file. The raw URL used by PEIMAN2 is:

```text
https://raw.githubusercontent.com/pnickchi/PEIMAN2-database/main/databases/config.json
```

## How PEIMAN2 uses this repository

In PEIMAN2, users can download the latest database version with:

```r
update_peiman_database()
```

or a specific version with:

```r
update_peiman_database(version = "2026-03-06")
```

Downloaded databases are cached locally on the user's machine in the PEIMAN2
user cache directory:

```r
tools::R_user_dir("PEIMAN2", which = "cache")
```

The PEIMAN2 package can then use either the bundled database, the latest cached
database, or a specific cached database version.

For example:

```r
runEnrichment(
  protein = proteins,
  os.name = "Homo sapiens (Human)",
  database_version = "latest"
)
```

or for reproducibility:

```r
runEnrichment(
  protein = proteins,
  os.name = "Homo sapiens (Human)",
  database_version = "2026-03-06"
)
```

The default value is `database_version = 'bundled'`, which uses the internal 
database included in the version of the package published on CRAN.


## Updating the database

Most users do **not** need to run the database update pipeline in this repository.
To use a newer PEIMAN database version in the PEIMAN2 package, users can call
the update function directly from PEIMAN2 package:

```r
update_peiman_database()
```

or download a specific database version with:

```r
update_peiman_database(version = "2026-03-06")
```

The steps below are only needed if you want to reproduce the database-generation
process locally, create a new database version for this repository, or generate
the most up-to-date database before a new version has been added here.

To create a new database version - create a branch to make a PR:

1. Run the database update pipeline:

```r
source("main.R")
```

2. Save the new database file in `databases/` using the format:

```text
peiman_database_YYYY-MM-DD.rds
```

3. Add the new version to `databases/config.json`.

4. Commit and push the updated database file and `databases/config.json`.


## Notes

- This repository is intended to store external PEIMAN database versions, not the
  main PEIMAN2 package source code.
  
- The PEIMAN2 CRAN package should not depend on internet access during package
  loading, examples, or CRAN checks.
  
- New database versions can be added here without submitting a new version of
  PEIMAN2 to CRAN.
  
- Older database versions should remain available when possible to support
  reproducible analyses.
