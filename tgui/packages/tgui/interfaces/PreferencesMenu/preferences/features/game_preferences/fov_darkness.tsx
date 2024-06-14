import { Feature, FeatureNumberInput } from '../base';

export const fov_darkness: Feature<number> = {
  name: 'FOV',
  category: 'GAMEPLAY',
  description:
    "Степень темноты FOV'а, когда вы надеваете что-либо, что закрывает вам глаза.",
  component: FeatureNumberInput,
};
