// Official RESOURCE.BIN files may keep menu commands as symbolic CMD_* values
// without serializing a ParamFile enum table.  They must therefore remain
// engine-provided constants after the world-start GGameState.Reset().
triAssertEq [CMD_WATCH, 0]
triAssertEq [CMD_JOIN, 10]
triAssertEq [CMD_RADIO_ALPHA, 56]
triAssertEq [CMD_REPLY_DONE, 66]
triAssertEq [CMD_ACTION_TARGET, 65536]
triEndTest
