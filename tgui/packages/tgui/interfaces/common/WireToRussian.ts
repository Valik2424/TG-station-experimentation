export type Wires = keyof typeof WIRE2RUSSIAN;

/** Icon map of jobs to their fontawesome5 (free) counterpart. */
export const WIRE2RUSSIAN = {
  blue: 'синий',
  brown: 'коричневый',
  crimson: 'малиновый',
  cyan: 'бирюзовый',
  gold: 'золотой',
  grey: 'серый',
  green: 'зелёный',
  magenta: 'пурпурный',
  orange: 'оранжевый',
  pink: 'розовый',
  purple: 'фиолетовый',
  red: 'красный',
  silver: 'серебряный',
  violet: 'лиловый',
  white: 'белый',
  yellow: 'жёлтый',
} as const;
