<p align="center">
    <img src="https://cloud.githubusercontent.com/assets/1342803/24797159/52fb0d88-1b90-11e7-85a5-359fff0496a4.png" width="320" alt="MySQL">
    <br>
    <br>
    <a href="http://beta.docs.vapor.codes/getting-started/hello-world/">
        <img src="http://img.shields.io/badge/read_the-docs-92A8D1.svg" alt="Documentation">
    </a>
    <a href="http://vapor.team">
        <img src="http://vapor.team/badge.svg" alt="Slack Team">
    </a>
    <a href="LICENSE">
        <img src="http://img.shields.io/badge/license-MIT-brightgreen.svg" alt="MIT License">
    </a>
    <a href="https://circleci.com/gh/vapor/mysql">
        <img src="https://circleci.com/gh/vapor/mysql.svg?style=shield" alt="Continuous Integration">
    </a>
    <a href="https://travis-ci.org/vapor/api-template">
    	<img src="https://travis-ci.org/vapor/api-template.svg?branch=master" alt="Build Status">
    </a>
    <a href="https://swift.org">
        <img src="http://img.shields.io/badge/swift-3.1-brightgreen.svg" alt="Swift 3.1">
    </a>
</center>

## Hello Vapor

An sample api implemented by using Swift on Vapor framework

### Install Vapor

[Reference to install vapor document](https://docs.vapor.codes/2.0/getting-started/install-on-macos/)

```
brew install vapor
```

### Getting start

- There are many ways to create a Vapor project, please checkout [here](https://docs.vapor.codes/2.0/getting-started/hello-world/). Created new Vapor sample project with template `api`, checkout command below.

```
vapor new Hello --template=api
```

### Compile and Run

```
vapor build
```

- Boot up the server by running the following command. You can now visit `localhost:8080/plaintext` in your browser or run.

```
vapor run serve
```

### Database

- You can work with manys different provider `SQL` `PostgreSQL`. By using [Fluent](https://docs.vapor.codes/2.0/fluent/getting-started/) that is an protocol take database stuffs easier.

- Want to know how integrate PostgreSQL into Vapor application, please checkout [here](https://medium.com/@johannkerr/persisting-data-with-vapor-and-postgresql-aa84a86dbfae)

### Deploy

- Vapor also provides us a cloud where you're able to deploy our application. It's called [Vapor Cloud](https://docs.vapor.codes/2.0/deploy/cloud/).

- Or traditionally, you can deploy to **Heroku** by following [this tutorial](https://videos.raywenderlich.com/screencasts/516-server-side-swift-with-vapor-deploying-to-heroku-with-postgresql)

### Api document

### Reference
- [Vapor Auth official document](https://docs.vapor.codes/2.0/auth/getting-started/)
- [Vapor Auth article](https://theswiftwebdeveloper.com/vapor-2-authentication-2e11129e37e0)
- [Make an api call with Vapor](https://razvan.net/2017/03/19/swift-on-server-making-an-api-call/)