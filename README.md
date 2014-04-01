Whetstone
=========

Getting Started
---------------

This repository comes equipped with a self-setup script!

    % ./bin/setup

After setting up, you can run the application using [foreman]:

    % foreman start

Make sure you edit .env to configure OAuth.

Since Whetstone OAuths against Learn, you'll need to have the Learn app running
to log in to Whetstone. Additionally, if you clear out your Learn database,
Whetstone's OAuth application will be lost, and you'll need to regenerate it
and update .env with the new keys.

Guidelines
----------

Use the following guides for getting things done, programming well, and
programming in style.

* [Protocol](http://github.com/thoughtbot/guides/blob/master/protocol)
* [Best Practices](http://github.com/thoughtbot/guides/blob/master/best-practices)
* [Style](http://github.com/thoughtbot/guides/blob/master/style)
