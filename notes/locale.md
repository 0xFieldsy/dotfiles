# Locale

`/usr/lib/locale` holds the compiled locale data (`localedef` output) used by C libraries to format dates, numbers, collation, etc. Each enabled locale gets its own subdirectory (e.g. `en_US.utf8`). The built-in `C` and `POSIX` locales need no directory here; `C.utf8` does.

`/usr/share/locale` holds translation message catalogs (`.mo` files). Each subdirectory contains translations for system programs that support that language. English-speaking programs read from `en`.

`/etc/locale.conf` is the system-wide default locale, read by systemd and most login processes. On Debian/Ubuntu it is also available as `/etc/default/locale`, which is a symlink.

> [!NOTE]
> Locale storage varies by distribution. Debian/Ubuntu commonly keep one directory per compiled locale, while other distributions use a single `/usr/lib/locale/locale-archive` file instead. Translation catalogs in `/usr/share/locale` are separate from compiled locale data and normally contain many languages.

## Clean up

Both locale directories are typically full of locales you will never use. The procedure below keeps only `C.UTF-8` and `en_US.UTF-8` for locale data, and only `en` for translations.

### Enable only the locales you want

Edit `/etc/locale.gen`, which lists one locale per line (commented out by default):

```sh
# Comment out any line that is currently uncommented
sudo sed -i '/^[^#]/ s/^/# /' /etc/locale.gen

# Enable C.UTF-8 and en_US.UTF-8
sudo sed -i 's/^# C.UTF-8 UTF-8/C.UTF-8 UTF-8/' /etc/locale.gen
sudo sed -i 's/^# en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen
```

### Remove unwanted compiled locales

```sh
sudo find /usr/lib/locale -mindepth 1 -maxdepth 1 -type d ! -name 'C.utf8' ! -name 'en_US.utf8' -exec rm -rf {} +
```

### Remove unwanted translations

```sh
sudo find /usr/share/locale -mindepth 1 -maxdepth 1 -type d ! -name 'en' -exec rm -rf {} +
```

### Regenerate enabled locales

```sh
sudo locale-gen
```

### Set the default locale

```sh
sudo update-locale LANG=en_US.UTF-8 LC_ALL=en_US.UTF-8

# Update current shell
source /etc/default/locale
```
