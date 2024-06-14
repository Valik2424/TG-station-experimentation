import { multiline } from 'common/string';
import {
  CheckboxInput,
  Feature,
  FeatureNumberInput,
  FeatureToggle,
} from '../base';

export const enable_tips: FeatureToggle = {
  name: 'Enable tooltips',
  name_ru: 'Включить подсказки',
  category: 'TOOLTIPS',
  description: multiline`
    Подсказки при наведении на предметы.
  `,
  component: CheckboxInput,
};

export const tip_delay: Feature<number> = {
  name: 'Tooltip delay (in milliseconds)',
  name_ru: 'Задержка подсказки (в миллисекундах)',
  category: 'TOOLTIPS',
  description: multiline`
    Как долго должна отображаться подсказка при наведении на предметы?
  `,
  component: FeatureNumberInput,
};
