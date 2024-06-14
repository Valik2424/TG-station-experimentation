import {
  CheckboxInput,
  FeatureNumberInput,
  FeatureNumeric,
  FeatureToggle,
} from '../base';

export const chat_on_map: FeatureToggle = {
  name: 'Enable Runechat',
  name_ru: 'Включить рунчат',
  category: 'RUNECHAT',
  description: 'Сообщения будут отображаться над головами.',
  component: CheckboxInput,
};

export const see_chat_non_mob: FeatureToggle = {
  name: 'Enable Runechat on objects',
  name_ru: 'Включить рунчат для объектов',
  category: 'RUNECHAT',
  description: 'Сообщения будут отображаться над объектами, когда они говорят.',
  component: CheckboxInput,
};

export const see_rc_emotes: FeatureToggle = {
  name: 'Enable Runechat emotes',
  name_ru: 'Включить рунчат для эмоутов',
  category: 'RUNECHAT',
  description: 'Эмоуты будут отображаться над головами.',
  component: CheckboxInput,
};

export const max_chat_length: FeatureNumeric = {
  name: 'Max chat length',
  name_ru: 'Максимальная длина сообщения',
  category: 'RUNECHAT',
  component: FeatureNumberInput,
};
