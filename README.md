# REREAD.io

Runs at https://www.reread.io

## Development

```
> git clone git@github.com:jollygoodcode/reread.git
> cd reread
> bin/setup
```

## Running Tests

```
> rspec
```

## Notes

This app experiments with:

- [Pocket API](https://getpocket.com/developer/)
- [party_foul](https://github.com/dockyard/party_foul)
- [ahoy_email](https://github.com/ankane/ahoy_email)

## ENV

- For POCKET_CONSUMER_KEY_V<number>, read Step 1 of https://getpocket.com/developer/docs/authentication
- For PARTYFOUL_*, create an oauth token

## Why `POCKET_CONSUMER_KEY_V1` and `POCKET_CONSUMER_KEY_V2`?

When this App was first created, it only required `Read` permission.
Hence the API key was created with `Read` permission only.

However, in order for the "Archive on Pocket" feature to work,
the App would require `Modify` permission as well.

Unfortunately, Pocket doesn't allow permissions for an App to be updated once it's been created,
so the only way to make it work is to create a new API key in Pocket with `Read` and `Modify` permissions.

Since there are users who have signed in using the earlier API key, and they might not sign in again,
the App thus have to support using the earlier API key `POCKET_CONSUMER_KEY_V1` for these users,
and use the new API key (`POCKET_CONSUMER_KEY_V2`) for the new users (or users who re-auth).
