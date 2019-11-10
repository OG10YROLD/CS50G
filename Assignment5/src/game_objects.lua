--[[
    GD50
    Legend of Zelda

    Author: Colton Ogden
    cogden@cs50.harvard.edu
]]

GAME_OBJECT_DEFS = {
    ['switch'] = {
        type = 'switch',
        texture = 'switches',
        frame = 2,
        width = 16,
        height = 16,
        scaleX = 1,
        scaleY = 1,
        solid = false,
        defaultState = 'unpressed',
        states = {
            ['unpressed'] = {
                frame = 2
            },
            ['pressed'] = {
                frame = 1
            }
        }
    },
    ['pot'] = {
       type = 'pot',
       texture = 'tiles',
       frame = 14,
       width = 16,
       height = 16,
       scaleX = 1,
       scaleY = 1,
       solid = true,
       defaultState = 'idle',
       states = {
            ['idle'] = {
                frame = 14
            },
            ['carried'] = {
                frame = 14
            },
            ['thrown-left'] = {
                frame = 14
            },
            ['thrown-right'] = {
                frame = 14
            },
            ['thrown-up'] = {
                frame = 14
            },
            ['thrown-down'] = {
                frame = 14
            },
            ['broken'] = {
                frame = 52
            },
            ['completely-broken'] = {
                frame = 52
            }
       }
    },
    ['heart'] = {
        type = 'heart',
        texture = 'hearts',
        frame = 5,
        width = 16,
        height = 16,
        scaleX = 0.5,
        scaleY = 0.5,
        solid = false,
        defaultState = 'uncollected',
        states = {
            ['uncollected'] = {
                frame = 5
            }
        }
    }
}