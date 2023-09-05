<div id="top"></div>

<!-- PROJECT LOGO -->
<br />
<div align="center">
  
<h1 align="center">Siba project - Backend</h1>

<h3 align="center">
    This project was created on the courses Softala-projekti / Software Project<br />
<br />
</div>

## sala ja nimi db
user: root
pass: secret

## start and stop db
brew services start mariadb
brew services stop mariadb

## Creators

<p>SIBA22S Softala team</p>
<p>SIBA23K Softala team</p>
<p>SWP23K team</p>
<!-- ABOUT THE PROJECT -->

## About the project

Copyrights reserved. This Project is collaborative work, which aims at building an information system that makes it possible to calculate and optimize teaching space and equipment usage for different lessons.

<p align="right">(<a href="#top">back to top</a>)</p>

### Backend technology and other useful resources

- [Mariadb](https://mariadb.org/)
- [Node](https://nodejs.org/en/)
- [Winston Logger](https://www.npmjs.com/package//winston)
- [Express-validator](https://www.npmjs.com/package/express-validator)
- [Dotenv](https://www.npmjs.com/package/dotenv)
- [Express](https://www.npmjs.com/package/express)
- [Body-parser](https://www.npmjs.com/package/body-parser)
- [Cors](https://www.npmjs.com/package/cors)
- [Mysql](https://www.mysql.com/)
- [Nodemon](https://www.npmjs.com/package/nodemon)

<p align="right">(<a href="#top">back to top</a>)</p>

<!-- GETTING STARTED -->

## Beginning

Backend side installation instructions

### Installation

1. Install [Mariadb](https://www.mariadbtutorial.com/getting-started/install-mariadb/) version 10.x or newer

2. Install Graphical SQL-editor: [DBeaver](https://dbeaver.io/) or [MySQL Workbench](https://www.mysql.com/products/workbench/)

3. Create to your chosen SQL editor database scheme called casedb. Run [000\_\_CreateALLdb.sql](https://github.com/haagahelia/Siba_be/blob/main/Database/SQL_Scripts/000__CreateALLdb.sql) script to create files to the database

4. Clone the repository
   ```sh
   git clone https://github.com/haagahelia/Siba_be.git
   ```

5. Change directory

   ```sh
   cd Sibe_be
   ```

6. Install needed packages

   ```sh
   npm install
   ```

7. Create the **.env** file. Add .env to the root of the project

   ```
   BE_API_URL_PREFIX=/api
   BE_SERVER_PORT=3001
   DB_DRIVER_MODULE=mysql
   DB_HOST=localhost
   DB_PORT=3306
   DB_USER=<<DB Username>>
   DB_PASSWORD=<<DB password>>
   DB_DATABASE=casedb
   DB_DEBUG=true
   DB_MULTIPLE_STATEMENTS=true
   DB_CONNECTION_POOL_MIN=1
   DB_CONNECTION_POOL_MAX=7
   SECRET_TOKEN=<<Secret token here for the JWT>>

   ```

   The secret_token has to be something of the length and format of: A3fs9t395dsgSDf3fRsTse349. But not that one! Hardening process should
   change it for the real deployment of the backend. This particular one A3fs... should not be used even for testing!
   This is visible in the internet. It's just a dummy value to help randomizing the real one.

   Be context aware! E.g. in the list above the ports are usually changed. And if you use a tunnel, then you target the tunnel port, not the real ports. Ask help! Usually one excel has all the dev time secrets for you.

8. Application launch

   ```sh
   npm start
   ```

   Attention! If it doesn't boot install:

   ```sh
   npm install -g nodemon
   ```

9. Attention! Follow the [Frontend repo](https://github.com/haagahelia/siba-fe) installation guide as well

<p align="right">(<a href="#top">back to top</a>)</p>
