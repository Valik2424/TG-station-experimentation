import { createDropdownInput, Feature } from '../base';

export const scaling_method: Feature<string> = {
  name: 'Scaling method',
  name_ru: 'Метод скалирования',
  category: 'UI',
  component: createDropdownInput({
    blur: 'Bilinear',
    distort: 'Nearest Neighbor',
    normal: 'Point Sampling',
  }),
};
