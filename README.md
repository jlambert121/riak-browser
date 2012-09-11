#What?

A simple data browser and editor for Riak databases.  riak-browser can be used to add, delete, copy, and edit JSON documents and is intended to be used in development environments.  It is not recommended for use on production databases since riak-browser relies on listing buckets and keys.

### Installation/Quick start
```
gem install riak multi_json oj thin
git clone https://github.com/jlambert121/riak-browser.git
cd riak-browser
thin start -R config.ru
```

###Config

This is a Sinatra application that can be deployed in Passenger or run with thin.  Configuration is stored in config.ru.

###TODO
Things on the someday list:
1. Better (some) error handling
2. Display/manage links
3. Display/manage indexes
4. Support other document types
5. Index queries
6. Probably lots of bug fixes

### How to Contribute

1. Fork this repo and create a new topic branch.
2. Make your bug fix or enhancement.
3. Send a pull request -- please include a short description of your fix or enhancement and one fix or enhancement per pull request.
4. Enjoy your awesomeness.

###Contact

Justin Lambert / jlambert@bufferfish.com
