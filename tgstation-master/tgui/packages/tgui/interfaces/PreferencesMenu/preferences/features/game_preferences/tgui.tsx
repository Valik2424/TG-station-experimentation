import { CheckboxInput, FeatureToggle } from '../base';

export const tgui_fancy: FeatureToggle = {
  name: 'Enable fancy TGUI',
  name_ru: 'Включить новый TGUI',
  category: 'UI',
  description:
    'Делает TGUI окна красивее, но может вызывать проблемы совместимости.',
  component: CheckboxInput,
};

export const tgui_input: FeatureToggle = {
  name: 'Input: Enable TGUI',
  name_ru: 'Input: Включить TGUI',
  category: 'UI',
  description: 'Отображает поля ввода в стиле TGUI.',
  component: CheckboxInput,
};

export const tgui_input_large: FeatureToggle = {
  name: 'Input: Larger buttons',
  name_ru: 'Input: Большие кнопки',
  category: 'UI',
  description: 'Увеличивает TGUI кнопки',
  component: CheckboxInput,
};

export const tgui_input_swapped: FeatureToggle = {
  name: 'Input: Swap Submit/Cancel buttons',
  name_ru: 'Input: Поменять кнопки Submit/Cancel местами',
  category: 'UI',
  component: CheckboxInput,
};

export const tgui_lock: FeatureToggle = {
  name: 'Lock TGUI to main monitor',
  name_ru: 'Закрепить TGUI на главном мониторе',
  category: 'UI',
  component: CheckboxInput,
};

export const tgui_say_light_mode: FeatureToggle = {
  name: 'Say: Light mode',
  name_ru: 'Say: Светлая тема',
  category: 'UI',
  component: CheckboxInput,
};
