# reread.io

[![Code Climate](https://codeclimate.com/github/jollygoodcode/reread/badges/gpa.svg)](https://codeclimate.com/github/jollygoodcode/reread)

Read and Learn again - Time to rediscover those saved and forgotten bookmarks.

reread.io is a service which sends you an email (everyday or weekly) containing your unread and/or archived [Pocket](https://getpocket.com) links.

You can use it as a service at https://www.reread.io.

Alternatively, you can also host an instance of it on Heroku. Read the Setup that follows.

_You might want to read the "[Learnings from Building reread.io](https://medium.com/jolly-good-notes/learnings-from-building-reread-io-46f57871e124#.aenkre6w2)" too._

## Deploy on Heroku

### 1. Deploy

[![Deploy](https://www.herokucdn.com/deploy/button.svg)](https://heroku.com/deploy)

After you have deployed the app on Heroku, the following Elements would have been enabled:

- Heroku Hobby Postgres Database
- Heroku Hobby Redis
- SendGrid

### 2. Setup ENV Config

#### Pocket API

```
heroku config:add POCKET_CONSUMER_KEY_V2=...
```

Read Step 1 of https://getpocket.com/developer/docs/authentication to obtain a Pocket API Key.

IMPORTANT! You will need `modify` and `read` permissions for your Pocket API key.

#### `WWW_HOSTNAME`

```
heroku config:add WWW_HOSTNAME=<reread-clone-name>.herokuapp.com
```

This is required for ActionMailer config.

#### Sidekiq Settings

Read our [blog post](http://jollygoodcode.com/blog/2015/12/08/optimum-sidekiq-configuration-on-heroku-with-puma.html) to understand all these settings.

Otherwise, these are sane defaults:

```
heroku config:add DB_POOL=20
heroku config:add DB_REAPING_FREQUENCY=10
heroku config:add MAX_REDIS_CONNECTION=30
heroku config:add NUMBER_OF_WEB_DYNOS=1
heroku config:add NUMBER_OF_WORKER_DYNOS=1
```

### 3. Optional

We use [PartyFoul](https://github.com/dockyard/party_foul) for error tracking. Follow their README to get it setup.

ENV vars required:

```
heroku config:add PARTYFOUL_OAUTH_TOKEN=...
heroku config:add PARTYFOUL_OWNER=...
heroku config:add PARTYFOUL_REPO=reread
```

We use [Skylight](https://www.skylight.io) for basic app performance monitoring. Sign up and follow their instructions.

ENV vars required:

```
heroku config:add SKYLIGHT_AUTHENTICATION=...
```

## Notes

Continuous Updates provided by [deppbot](https://www.deppbot.com) - Automated Security and Dependency Updates.

This app also experiments with:

- [Pocket API](https://getpocket.com/developer/)
- [party_foul](https://github.com/dockyard/party_foul)
- [ahoy_email](https://github.com/ankane/ahoy_email)

## FAQ

**I see `POCKET_CONSUMER_KEY_V1` and `POCKET_CONSUMER_KEY_V2`? Why?**

When this App was first created, it only required `read` permission.
Hence the API key was created with `read` only.

However, in order for the "Archive on Pocket" feature to work,
the App would require `Modify` permission as well.

Unfortunately, Pocket doesn't allow updates to the access permissions for an App once it's been created,
so the only way to make it work is to create a new API key in Pocket with `read` and `modify` permissions.

Since there are users (at https://www.reread.io) who have signed in using the earlier API key (and they may not sign in again)
the App thus have to support using `*_V1` for the old users and use `*_V2` for the new users (or users who re-auth).

_You only need `*_V2` set if you are deploying a new instance of reread._

## Contributing

Please see the [CONTRIBUTING.md](/CONTRIBUTING.md) file.

## Deployment

Please see the [DEPLOYMENT.md](/DEPLOYMENT.md) file.

## Credits

A huge THANK YOU to all our [contributors](https://github.com/jollygoodcode/reread/graphs/contributors)! :heart:

## License

Please see the [LICENSE.md](/LICENSE.md) file.

## Maintained by Jolly Good Code

[![Jolly Good Code](https://cloud.githubusercontent.com/assets/1000669/9362336/72f9c406-46d2-11e5-94de-5060e83fcf83.jpg)](http://www.jollygoodcode.com)

We specialise in rapid development of high quality MVPs. [Hire us](http://www.jollygoodcode.com/#get-in-touch) to turn your product idea into reality.
