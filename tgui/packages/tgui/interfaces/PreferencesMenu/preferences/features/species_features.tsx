import {
  FeatureColorInput,
  Feature,
  FeatureChoiced,
  FeatureDropdownInput,
  FeatureValueProps,
  FeatureChoicedServerData,
} from './base';

export const eye_color: Feature<string> = {
  name: 'Цвет глаз',
  component: FeatureColorInput,
};

export const facial_hair_color: Feature<string> = {
  name: 'Цвет бороды',
  component: FeatureColorInput,
};

export const facial_hair_gradient: FeatureChoiced = {
  name: 'Стиль градиента бороды',
  component: (
    props: FeatureValueProps<string, string, FeatureChoicedServerData>
  ) => {
    return <FeatureDropdownInput buttons {...props} />;
  },
};

export const facial_hair_gradient_color: Feature<string> = {
  name: 'Цвет градиента бороды',
  component: FeatureColorInput,
};

export const hair_color: Feature<string> = {
  name: 'Цвет причёски',
  component: FeatureColorInput,
};

export const hair_gradient: FeatureChoiced = {
  name: 'Стиль градиента причёски',
  component: (
    props: FeatureValueProps<string, string, FeatureChoicedServerData>
  ) => {
    return <FeatureDropdownInput buttons {...props} />;
  },
};

export const hair_gradient_color: Feature<string> = {
  name: 'Цвет градиента причёски',
  component: FeatureColorInput,
};

export const feature_human_ears: FeatureChoiced = {
  name: 'Уши',
  component: (
    props: FeatureValueProps<string, string, FeatureChoicedServerData>
  ) => {
    return <FeatureDropdownInput buttons {...props} />;
  },
};

export const feature_human_tail: FeatureChoiced = {
  name: 'Хвост',
  component: (
    props: FeatureValueProps<string, string, FeatureChoicedServerData>
  ) => {
    return <FeatureDropdownInput buttons {...props} />;
  },
};

export const feature_lizard_legs: FeatureChoiced = {
  name: 'Ноги',
  component: (
    props: FeatureValueProps<string, string, FeatureChoicedServerData>
  ) => {
    return <FeatureDropdownInput buttons {...props} />;
  },
};

export const feature_lizard_spines: FeatureChoiced = {
  name: 'Шипы',
  component: (
    props: FeatureValueProps<string, string, FeatureChoicedServerData>
  ) => {
    return <FeatureDropdownInput buttons {...props} />;
  },
};

export const feature_lizard_tail: FeatureChoiced = {
  name: 'Хвост',
  component: (
    props: FeatureValueProps<string, string, FeatureChoicedServerData>
  ) => {
    return <FeatureDropdownInput buttons {...props} />;
  },
};

export const feature_mcolor: Feature<string> = {
  name: 'Цвет кожи',
  component: FeatureColorInput,
};

export const underwear_color: Feature<string> = {
  name: 'Цвет белья',
  component: FeatureColorInput,
};

export const feature_vampire_status: Feature<string> = {
  name: 'Статус вампира',
  component: FeatureDropdownInput,
};

export const heterochromatic: Feature<string> = {
  name: 'Гетерохромия',
  component: FeatureColorInput,
};
