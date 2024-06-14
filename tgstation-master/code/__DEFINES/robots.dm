// AI defines

#define DEFAULT_AI_LAWID "default"
#define LAW_ZEROTH "zeroth"
#define LAW_INHERENT "inherent"
#define LAW_SUPPLIED "supplied"
#define LAW_ION "ion"
#define LAW_HACKED "hacked"

//AI notification defines
///Alert when a new Cyborg is created.
#define AI_NOTIFICATION_NEW_BORG 1
///Alert when a Cyborg selects a model.
#define AI_NOTIFICATION_NEW_MODEL 2
///Alert when a Cyborg changes their name.
#define AI_NOTIFICATION_CYBORG_RENAMED 3
///Alert when an AI disconnects themselves from their shell.
#define AI_NOTIFICATION_AI_SHELL 4
///Alert when a Cyborg gets disconnected from their AI.
#define AI_NOTIFICATION_CYBORG_DISCONNECTED 5

//transfer_ai() defines. Main proc in ai_core.dm
///Downloading AI to InteliCard
#define AI_TRANS_TO_CARD 1
///Uploading AI from InteliCard
#define AI_TRANS_FROM_CARD 2
///Malfunctioning AI hijacking mecha
#define AI_MECH_HACK 3

// Cyborg defines

/// If an item does this or more throwing damage it will slow a borg down on hit
#define CYBORG_THROW_SLOWDOWN_THRESHOLD 10

/// Special value to reset cyborg's lamp_cooldown
#define BORG_LAMP_CD_RESET -1

//Module slot define
///The third module slots is disabed.
#define BORG_MODULE_THREE_DISABLED (1<<0)
///The second module slots is disabed.
#define BORG_MODULE_TWO_DISABLED (1<<1)
///All modules slots are disabled.
#define BORG_MODULE_ALL_DISABLED (1<<2)

//Cyborg module selection
///First Borg module slot.
#define BORG_CHOOSE_MODULE_ONE 1
///Second Borg module slot.
#define BORG_CHOOSE_MODULE_TWO 2
///Third Borg module slot.
#define BORG_CHOOSE_MODULE_THREE 3

#define SKIN_ICON "skin_icon"
#define SKIN_ICON_STATE "skin_icon_state"
#define SKIN_PIXEL_X "skin_pixel_x"
#define SKIN_PIXEL_Y "skin_pixel_y"
#define SKIN_LIGHT_KEY "skin_light_key"
#define SKIN_HAT_OFFSET "skin_hat_offset"
#define SKIN_TRAITS "skin_traits"

/** Simple Animal BOT defines */

//Assembly defines
#define ASSEMBLY_FIRST_STEP 1
#define ASSEMBLY_SECOND_STEP 2
#define ASSEMBLY_THIRD_STEP 3
#define ASSEMBLY_FOURTH_STEP 4
#define ASSEMBLY_FIFTH_STEP 5
#define ASSEMBLY_SIXTH_STEP 6
#define ASSEMBLY_SEVENTH_STEP 7
#define ASSEMBLY_EIGHTH_STEP 8
#define ASSEMBLY_NINTH_STEP 9

//Bot defines, placed here so they can be read by other things!
/// Delay between movemements
#define BOT_STEP_DELAY 4
/// Maximum times a bot will retry to step from its position
#define BOT_STEP_MAX_RETRIES 5
/// Default view range for finding targets.
#define DEFAULT_SCAN_RANGE 7
//Amount of time that must pass after a Commissioned bot gets saluted to get another.
#define BOT_COMMISSIONED_SALUTE_DELAY (60 SECONDS)

//Bot mode defines displaying how Bots act
///The Bot is currently active, and will do whatever it is programmed to do.
#define BOT_MODE_ON (1<<0)
///The Bot is currently set to automatically patrol the station.
#define BOT_MODE_AUTOPATROL (1<<1)
///The Bot is currently allowed to be remote controlled by Silicon.
#define BOT_MODE_REMOTE_ENABLED (1<<2)
///The Bot is allowed to have a ghost placed in control of it.
#define BOT_MODE_CAN_BE_SAPIENT (1<<3)
///The Bot is allowed to be possessed if it is present on mapload.
#define BOT_MODE_ROUNDSTART_POSSESSION (1<<4)

//Bot cover defines indicating the Bot's status
///The Bot's cover is open and can be modified/emagged by anyone.
#define BOT_COVER_OPEN (1<<0)
///The Bot's cover is locked, and cannot be opened without unlocking it.
#define BOT_COVER_LOCKED (1<<1)
///The Bot is emagged.
#define BOT_COVER_EMAGGED (1<<2)
///The Bot has been hacked by a Silicon, emagging them, but revertable.
#define BOT_COVER_HACKED (1<<3)

//Bot types
/// Secutritrons (Beepsky)
#define SEC_BOT "Секьюритрон"
/// ED-209s
#define ADVANCED_SEC_BOT "ED-209"
/// MULEbots
#define MULE_BOT "МУЛбот"
/// Floorbots
#define FLOOR_BOT "Флурбот"
/// Cleanbots
#define CLEAN_BOT "Клинбот"
/// Medibots
#define MED_BOT "Медбот"
/// Honkbots & ED-Honks
#define HONK_BOT "Хонкбот"
/// Firebots
#define FIRE_BOT "Пожарный бот"
/// Hygienebots
#define HYGIENE_BOT "Hygienebot"
/// Vibe bots
#define VIBE_BOT "Vibebot"

// General Bot modes //
/// Idle
#define BOT_IDLE "Ожидает"
/// Found target, hunting
#define BOT_HUNT "В погоне"
/// Currently tipped over.
#define BOT_TIPPED "Опрокинут"
/// Start patrol
#define BOT_START_PATROL "Начинаю патруль"
/// Patrolling
#define BOT_PATROL "Патрулирую"
/// Summoned to a location
#define BOT_SUMMON "Вызван через ПДА"
/// Responding to a call from the AI
#define BOT_RESPONDING "Перехожу к маршрутной точке ИИ"
/// Currently moving
#define BOT_MOVING "Выдвигаюсь"

// Unique modes //
/// Secbot - At target, preparing to arrest
#define BOT_PREP_ARREST "Готовлюсь арестовать"
/// Secbot - Arresting target
#define BOT_ARREST "Арестовываю"
/// Cleanbot - Cleaning
#define BOT_CLEANING "Чищу"
/// Hygienebot - Cleaning unhygienic humans
#define BOT_SHOWERSTANCE "Ищу грязь"
/// Floorbots - Repairing hull breaches
#define BOT_REPAIRING "Чиню"
/// Medibots - Healing people
#define BOT_HEALING "Лечу"
/// MULEbot - Moving to deliver
#define BOT_DELIVER "Двигаюсь к месту доставки"
/// MULEbot - Returning to home
#define BOT_GO_HOME "Двигаюсь к рабочему месту"
/// MULEbot - Blocked
#define BOT_BLOCKED "Нет маршрута"
/// MULEbot - Computing navigation
#define BOT_NAV "Невозможно достигнуть заданной точки"
/// MULEbot - Waiting for nav computation
#define BOT_WAIT_FOR_NAV "Вычисляю маршрут"
/// MULEbot - No destination beacon found (or no route)
#define BOT_NO_ROUTE "Двигаюсь на стартовую позицию"

//Secbot and ED209 judgement criteria bitflag values
#define JUDGE_EMAGGED (1<<0)
#define JUDGE_IDCHECK (1<<1)
#define JUDGE_WEAPONCHECK (1<<2)
#define JUDGE_RECORDCHECK (1<<3)

//SecBOT defines on arresting
///Whether arrests should be broadcasted over the Security radio
#define SECBOT_DECLARE_ARRESTS (1<<0)
///Will arrest people who lack an ID card
#define SECBOT_CHECK_IDS (1<<1)
///Will check for weapons, taking Weapons access into account
#define SECBOT_CHECK_WEAPONS (1<<2)
///Will check Security record on whether to arrest
#define SECBOT_CHECK_RECORDS (1<<3)
///Whether we will stun & cuff or endlessly stun
#define SECBOT_HANDCUFF_TARGET (1<<4)

DEFINE_BITFIELD(security_mode_flags, list(
	"SECBOT_DECLARE_ARRESTS" = SECBOT_DECLARE_ARRESTS,
	"SECBOT_CHECK_IDS" = SECBOT_CHECK_IDS,
	"SECBOT_CHECK_WEAPONS" = SECBOT_CHECK_WEAPONS,
	"SECBOT_CHECK_RECORDS" = SECBOT_CHECK_RECORDS,
	"SECBOT_HANDCUFF_TARGET" = SECBOT_HANDCUFF_TARGET,
))

//MedBOT defines
///Whether to declare if someone (we are healing) is in critical condition
#define MEDBOT_DECLARE_CRIT (1<<0)
///If the bot will stand still, only healing those next to it.
#define MEDBOT_STATIONARY_MODE (1<<1)
///Whether the bot will randomly speak from time to time. This will not actually prevent all speech.
#define MEDBOT_SPEAK_MODE (1<<2)

DEFINE_BITFIELD(medical_mode_flags, list(
	"MEDBOT_DECLARE_CRIT" = MEDBOT_DECLARE_CRIT,
	"MEDBOT_STATIONARY_MODE" = MEDBOT_STATIONARY_MODE,
	"MEDBOT_SPEAK_MODE" = MEDBOT_SPEAK_MODE,
))

//cleanBOT defines on what to clean
#define CLEANBOT_CLEAN_BLOOD (1<<0)
#define CLEANBOT_CLEAN_TRASH (1<<1)
#define CLEANBOT_CLEAN_PESTS (1<<2)
#define CLEANBOT_CLEAN_DRAWINGS (1<<3)

DEFINE_BITFIELD(janitor_mode_flags, list(
	"CLEANBOT_CLEAN_BLOOD" = CLEANBOT_CLEAN_BLOOD,
	"CLEANBOT_CLEAN_TRASH" = CLEANBOT_CLEAN_TRASH,
	"CLEANBOT_CLEAN_PESTS" = CLEANBOT_CLEAN_PESTS,
	"CLEANBOT_CLEAN_DRAWINGS" = CLEANBOT_CLEAN_DRAWINGS,
))

//bot navigation beacon defines
#define NAVBEACON_PATROL_MODE "patrol"
#define NAVBEACON_PATROL_NEXT "next_patrol"
#define NAVBEACON_DELIVERY_MODE "delivery"
#define NAVBEACON_DELIVERY_DIRECTION "dir"

// Defines for lines that bots can speak which also have corresponding voice lines

#define ED209_VOICED_DOWN_WEAPONS "Пожалуйста, опустите оружие. У вас 20 секунд чтобы подчиниться."

#define HONKBOT_VOICED_HONK_HAPPY "ХОНК!!!"
#define HONKBOT_VOICED_HONK_SAD "Хонк..."

#define BEEPSKY_VOICED_CRIMINAL_DETECTED "Преступник обнаружен!"
#define BEEPSKY_VOICED_FREEZE "Стоять, мразь!"
#define BEEPSKY_VOICED_JUSTICE "Приготовься к правосудию!"
#define BEEPSKY_VOICED_YOUR_MOVE "Твой ход, чудила."
#define BEEPSKY_VOICED_I_AM_THE_LAW "Я! ЗДЕСЬ!! ЗАКОН!!!"
#define BEEPSKY_VOICED_SECURE_DAY "Безопасного Вам дня."

#define FIREBOT_VOICED_FIRE_DETECTED "Обнаружено пламя!"
#define FIREBOT_VOICED_STOP_DROP "Стой, падай и катайся!"
#define FIREBOT_VOICED_EXTINGUISHING "Тушу пламя!"
#define FIREBOT_VOICED_NO_FIRES "Пламени не обнаружено."
#define FIREBOT_VOICED_ONLY_YOU "Только Вы можете предотвратить пожары."
#define FIREBOT_VOICED_TEMPERATURE_NOMINAL "Температура в порядке."
#define FIREBOT_VOICED_KEEP_COOL "Будь хладнокровным."

#define HYGIENEBOT_VOICED_UNHYGIENIC "Грязнуля обнаружен. Пожалуйста, постойте смирно, чтобы я вас очистил."
#define HYGIENEBOT_VOICED_ENJOY_DAY "Наслаждайся своим чистым днём!"
#define HYGIENEBOT_VOICED_THREAT_AIRLOCK "Либо перестань бежать, либо я выковыряю твой труп из шлюза."
#define HYGIENEBOT_VOICED_FOUL_SMELL "Вернись сюда, вонючий ублюдок."
#define HYGIENEBOT_VOICED_TROGLODYTE "Я просто хочу почистить тебя, троглодит."
#define HYGIENEBOT_VOICED_GREEN_CLOUD "Если ты не вернёшься, я окутаю тебя зелёным облаком"
#define HYGIENEBOT_VOICED_ARSEHOLE "Просто, черт возьми, дай мне почистить тебя, засранец!"
#define HYGIENEBOT_VOICED_THREAT_ARTERIES "ХВАТИТ УБЕГАТЬ, ИЛИ Я ПЕРЕРЕЖУ ТЕБЕ ГЛОТКУ"
#define HYGIENEBOT_VOICED_STOP_RUNNING "ХВАТИТ. УБЕГАТЬ."
#define HYGIENEBOT_VOICED_FUCKING_FINALLY "Чёрт, наконец-то."
#define HYGIENEBOT_VOICED_THANK_GOD "Слава богу, ты, наконец-то, остановился."
#define HYGIENEBOT_VOICED_DEGENERATE "Очень вовремя, чёртов ты дегенерат."

#define MEDIBOT_VOICED_HOLD_ON "Эй! Погоди, я иду."
#define MEDIBOT_VOICED_WANT_TO_HELP "Подожди! Я хочу помочь!"
#define MEDIBOT_VOICED_YOU_ARE_INJURED "Кажется, ты ранен!"
#define MEDIBOT_VOICED_ALL_PATCHED_UP "Всё заштопано!"
#define MEDIBOT_VOICED_APPLE_A_DAY "Яблочко на ужин, и врач не нужен."
#define MEDIBOT_VOICED_FEEL_BETTER "Скоро полегчает!"
#define MEDIBOT_VOICED_STAY_WITH_ME	"Нет! Останься со мной!"
#define MEDIBOT_VOICED_LIVE	"Живи, чёрт возьми! ЖИВИ!!"
#define MEDIBOT_VOICED_NEVER_LOST "Я...Я никогда не терял пациентов. Сегодня, я имею ввиду."
#define MEDIBOT_VOICED_DELICIOUS "Восхитительно!"
#define MEDIBOT_VOICED_PLASTIC_SURGEON "Я знал что мне не следует становиться пластическим хирургом."
#define MEDIBOT_VOICED_MASK_ON "Эй, надень-ка маску!"
#define MEDIBOT_VOICED_ALWAYS_A_CATCH "There's always a catch, and I'm the best there is."
#define MEDIBOT_VOICED_LIKE_FLIES "Что это за медбей? Все дохнут как мухи."
#define MEDIBOT_VOICED_SUFFER "Зачем мы здесь? Чтобы страдать?"
#define MEDIBOT_VOICED_FUCK_YOU	"Пошёл ты..."
#define MEDIBOT_VOICED_NOT_A_GAME "Выключи компьютер. Это не игра."
#define MEDIBOT_VOICED_IM_DIFFERENT	"Я особенный!"
#define MEDIBOT_VOICED_FOURTH_WALL "Закрой Dreamseeker.exe сейчас же!"
#define MEDIBOT_VOICED_SHINDEMASHOU	"Shindemashou."
#define MEDIBOT_VOICED_WAIT	"Эй, постой..."
#define MEDIBOT_VOICED_DONT	"Пожалуйста, не надо..."
#define MEDIBOT_VOICED_TRUSTED_YOU "Я верил тебе..."
#define MEDIBOT_VOICED_NO_SAD "Нееееет..."
#define MEDIBOT_VOICED_OH_FUCK "Ох бля-"
#define MEDIBOT_VOICED_FORGIVE "Я прощаю тебя."
#define MEDIBOT_VOICED_THANKS "Спасибо тебе!"
#define MEDIBOT_VOICED_GOOD_PERSON "Ты хороший человек."
#define MEDIBOT_VOICED_BEHAVIOUR_REPORTED "О твоём поведении доложено куда следует. Хорошего дня."
#define MEDIBOT_VOICED_ASSISTANCE "Запрашиваю помощь."
#define MEDIBOT_VOICED_PUT_BACK	"Пожалуйста, поставьте меня."
#define MEDIBOT_VOICED_IM_SCARED "Пожалуйста, мне страшно!"
#define MEDIBOT_VOICED_NEED_HELP "Мне это не нравится, мне нужна помощь!"
#define MEDIBOT_VOICED_THIS_HURTS "Как больно! По настоящему больно!"
#define MEDIBOT_VOICED_THE_END "Это конец?"
#define MEDIBOT_VOICED_NOOO	"Неееет!"
