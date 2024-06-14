import {
  CheckboxInput,
  FeatureColorInput,
  FeatureToggle,
  Feature,
  FeatureChoiced,
  FeatureDropdownInput,
} from '../base';

export const screentip_color: Feature<string> = {
  name: 'Screentips: Screentips color',
  name_ru: 'Цвет подсказок',
  category: 'UI',
  component: FeatureColorInput,
};

export const screentip_images: FeatureToggle = {
  name: 'Screentips: Allow images',
  name_ru: 'Показывать картинки в подсказках',
  category: 'UI',
  component: CheckboxInput,
};

export const screentip_pref: FeatureChoiced = {
  name: 'Screentips: Enable screentips',
  name_ru: 'Включить подсказки',
  category: 'UI',
  component: FeatureDropdownInput,
};
