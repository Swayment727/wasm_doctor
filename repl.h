#include <stdbool.h>

extern const char *g_repl_prompt;
extern struct repl_state *g_repl_state;
extern bool g_repl_use_jump_table;
extern bool g_repl_print_stats;

int repl(void);
void repl_reset(struct repl_state *state);
int repl_load(struct repl_state *state, const char *modname,
              const char *filename);
int repl_register(struct repl_state *state, const char *modname,
                  const char *register_name);
int repl_invoke(struct repl_state *state, const char *moodname,
                const char *cmd, bool print_result);
void repl_print_version(void);

int repl_load_wasi(struct repl_state *state);
int repl_set_wasi_args(struct repl_state *state, int argc, char *const *argv);
int repl_set_wasi_prestat(struct repl_state *state, const char *path);
