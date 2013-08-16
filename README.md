#What?

A simple data browser and editor for Riak databases for viewing and editing JSON documents..  riak-browser can be used to add, delete, copy, and edit JSON documents and is intended to be used in development environments.  It is not recommended for use on production databases since riak-browser relies on listing buckets and keys.

### Installation/Quick start
```
git clone https://github.com/jlambert121/riak-browser.git
cd riak-browser
bundle install OR bundle install --path vendor
thin start -R config.ru
```

To build an RPM package using fpm and a nasty build script:
```
git clone https://github.com/jlambert121/riak-browser.git
cd riak-browser/scripts
./build.sh
rpm -i /tmp/riak-browser-<version>-1.noarch.rpm
/etc/init.d/riak-browswer start
```

###Config

This is a Sinatra application that can be deployed in Passenger or run with thin.  Configuration is stored in config.ru.

###TODO
#####Things on the someday list:

1. Better (some) error handling
2. Display/manage links
3. Display (done)/edit indexes
4. Support other document types
5. Support binary data
6. Index queries
7. View/Edit bucket properties
7. Probably lots of bug fixes

### How to Contribute

1. Fork this repo and create a new topic branch.
2. Make your bug fix or enhancement.
3. Send a pull request -- please include a short description of your fix or enhancement and one fix or enhancement per pull request.
4. Enjoy your awesomeness.

###Contact

Justin Lambert / jlambert@letsevenup.com
