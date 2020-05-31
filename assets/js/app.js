import css from '../css/app.css';

import './polyfill';
import snowfall from './snowflake';

const stopSnowfall = snowfall(document.querySelector('.snowflakes'));
