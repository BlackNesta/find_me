## Brand Model — Bugs & Fixes

- **Missing uniqueness validation** — DB had a case-insensitive unique index, model didn't validate it (`valid?` true, then `save` raised `RecordNotUnique`). → `uniqueness: { case_sensitive: false }`
- **Whitespace bypassed uniqueness** — `"Apple"`, `" Apple"`, `"Apple "` saved as separate rows. → normalization (below)
- **No length guard** — `name` was unbounded. → `length: { maximum: 255 }` + migration adding DB-level `limit: 255`
- **Seed not idempotent** — case-sensitive `exists?` mismatched the index, re-seeding could crash. → `Brand.where("lower(name) = lower(?)", "Apple").first_or_create!(name: "Apple")`

## Models — Setting & User

- **`users_count`** column added to `brands`, kept in sync via `counter_cache` on `Setting#belongs_to :brand`.
- **`Setting`** is the join (`user_id`, `brand_id`, `key`, `value`); unique `(user_id, brand_id)` at model + DB → one setting per user-brand pair. `key`/`value` optional (a setting can be a bare membership).
- **`User`** (`first_name`, `last_name`, `email`); `has_many :brands, through: :settings`; presence, case-insensitive unique email (DB-backed), format via `email_validator`.
- **Normalization** (`NormalizedText` concern, via Rails `normalizes`) on brand name + user fields: downcase → remove all whitespace → cut every `"test"` (repeating).

## Web layer (root page)

- **Brand-name autosave** — `simple_form` + a debounced Stimulus `autosave` controller; `BrandsController#update` (via `UpdateBrand` service actor) responds with a Turbo Stream status ("Saved" / errors).
- **Create / destroy users for a brand** — `UsersController` (create via `AddUserToBrand` actor) with Turbo Streams that append/remove the user row and live-update `users_count`. `UserDecorator` (draper) for display.

## Design decisions

- **Membership-based**: a `Setting` is created when a user is linked to a brand (not auto-provisioned for every brand). `brand.users_count` is per-brand.
- **Create reuses an existing user** matched by normalized email (no attribute mutation); **destroy removes only the membership** (the setting), keeping the user — so multi-brand users are unaffected.
- **Race safety**: uniqueness is enforced by DB indexes; the create path rescues `RecordNotUnique`; the autosave aborts in-flight requests so a stale value can't overwrite a newer one.

## Tests (78 examples, 0 failures)

- Model specs incl. DB-constraint tests via `insert_all!` (proves the indexes, not just validations).
- Actor specs for `UpdateBrand` / `AddUserToBrand` (create, reuse, duplicate, invalid).
- Request specs for brand update + user create/destroy.
- **Browser system spec** (Capybara + Selenium) driving the real autosave + Turbo Streams — caught a real bug where the autosave read the hidden `_method` field instead of the name input.

## Dependencies

Only existing gems used (`simple_form`, `service_actor`, `draper`, `email_validator`, Turbo/Stimulus, Capybara/Selenium). `Gemfile` untouched.

