import { multiline } from 'common/string';
import { CheckboxInput, FeatureToggle } from '../base';

export const darkened_flash: FeatureToggle = {
  name: 'Enable darkened flashes',
  name_ru: 'Темные вспышки',
  category: 'GAMEPLAY',
  description: multiline`
    Когда включено, вспышка будет вызывать темный экран, вместо белого.
  `,

  component: CheckboxInput,
};
