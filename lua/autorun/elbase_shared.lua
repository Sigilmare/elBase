elBase = elBase or {}

elBase.Version = 1.1

-- No. Just because you changed/added small things doesn't mean you should go here.
elBase.Credits = {
    {"76561198171603670", "Creator of elBase :D"},
    {"76561198913877245", "Various GitHub contributions"},
    
}

-- Blacklisted users cannot use any of my addons.
local REASON_AWPONG = "Affiliated with \"PowerOverNight Gaming\""
local REASON_AWZLC = "Affiliated with \"ZombieLand Community\""
elBase.Blacklist = {
    {"76561198205577016", REASON_AWPONG},
    {"76561198050109523", REASON_AWPONG},
    {"76561198866986264", REASON_AWPONG},
    {"76561198274314803", REASON_AWPONG},
    {"76561198124546592", REASON_AWPONG},
    {"76561198206304921", REASON_AWZLC},
    {"76561198965259619", REASON_AWZLC},
    {"76561199136923537", REASON_AWZLC..", it has to be done."},
    {"76561199051535675", REASON_AWZLC},
    {"76561198440949403", REASON_AWZLC},
    {"76561198135248764", REASON_AWZLC},
    {"76561198852541273", REASON_AWZLC},
    {"76561198045694966", REASON_AWZLC},
    {"76561198272180359", REASON_AWZLC},
    {"76561198010367820", REASON_AWZLC},
    {"76561198808612658", REASON_AWZLC},
    {"76561198097536249", "No."},
    {"76561199163486631", "No."},
}