import { createDropdownInput, Feature } from '../base';

export const multiz_performance: Feature<number> = {
  name: 'Multi-Z Detail',
  name_ru: 'Ограничение глубины',
  category: 'GAMEPLAY',
  description: 'Детализация Multi-Z (чем ниже, тем лучше производительность)',
  component: createDropdownInput({
    [-1]: 'Standard',
    2: 'High',
    1: 'Medium',
    0: 'Low',
  }),
};
