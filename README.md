# Nano-ORM

Nano ORM is a framework to make creating MTA SA scripts easier, especially any database connections.

It's inspired by laravel, which is a PHP MVC framework.

## DbClass
A class that is based on a database table will have to inherit from the DbClass class.
```lua
Vehicle = inherit(DbClass)
```
A subclass of DbClass will require you to set up the database, and database table name, and the database fields.
```lua
Vehicle.tableName = "vehicle"

Vehicle:int("model")
Vehicle:position()
Vehicle:rotation()
Vehicle:foreign("owner")
```
Details on the various available database fields methods of DbClass can be found at [the wiki](https://github.com/NanoBob/Nano-ORM/wiki/DbClass "DbClass wiki")
