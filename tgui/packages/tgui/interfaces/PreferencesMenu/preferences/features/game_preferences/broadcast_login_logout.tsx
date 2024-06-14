import { multiline } from 'common/string';
import { CheckboxInput, FeatureToggle } from '../base';

export const broadcast_login_logout: FeatureToggle = {
  name: 'Broadcast login/logout',
  name_ru: 'Оповещать о входе/выходе',
  category: 'GAMEPLAY',
  description: multiline`
    Когда включено, вход и выход будет показан в дедчате.
  `,
  component: CheckboxInput,
};
