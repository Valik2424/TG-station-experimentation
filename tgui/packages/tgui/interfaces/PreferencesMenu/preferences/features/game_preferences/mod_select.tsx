import { Feature, FeatureDropdownInput } from '../base';

export const mod_select: Feature<string> = {
  name: 'MOD active module key',
  name_ru: 'Клавиша активного модуля МОДа',
  category: 'GAMEPLAY',
  description:
    'Клавиша, которую нужно нажать, чтобы использовать активный модуль МОДа.',
  component: FeatureDropdownInput,
};
