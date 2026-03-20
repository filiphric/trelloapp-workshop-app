import { PluginOption } from 'vite';
import boardRoutes from './api/board-routes';
import cardRoutes from './api/card-routes';
import listRoutes from './api/list-routes';
import resetRoutes from './api/reset-routes';
import userRoutes from './api/user-routes';
import loginRoutes from './api/login-routes';
import signupRoutes from './api/signup-routes';
import locationRoutes from './api/location-routes';
import constants from '../constants';
const { SERVER } = constants

export const startServer = (): PluginOption => {

  const jsonServer = require('json-server');
  const app = jsonServer.create();
  const auth = require('json-server-auth');
  const nocache = require('nocache')
  const busboy = require('connect-busboy');
  const history = require('connect-history-api-fallback');
  const middleware = require('./middleware');

  const router = jsonServer.router('./backend/data/database.json');

  app.db = router.db;
  app.use(history());
  app.use(jsonServer.defaults({ static: '.', logger: false }));
  app.use(nocache());
  app.use(busboy());
  app.use(jsonServer.bodyParser);
  app.use(middleware);
  app.use('/login', loginRoutes)
  app.use('/signup', signupRoutes)
  app.use(jsonServer.rewriter({
    '/users/*': '/600/users/$1',
  }));
  app.use(auth);
  app.use('/boards', boardRoutes)
  app.use('/lists', listRoutes)
  app.use('/cards', cardRoutes)
  app.use('/users', userRoutes)
  app.use('/reset', resetRoutes)
  app.use('/location', locationRoutes)

  app.use(router);

  app.listen(SERVER);

  return null;
}

export const createServer = (): PluginOption => {
  return startServer()
}