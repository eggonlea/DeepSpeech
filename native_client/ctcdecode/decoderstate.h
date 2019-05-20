#ifndef DECODERSTATE_H_
#define DECODERSTATE_H_

#include <vector>

/* Struct for the beam search output, containing the tokens based on the vocabulary indices, and the timesteps
 * for each token in the beam search output
 */
struct DecoderState {
  int space_id;
  int blank_id;
  std::vector<PathTrie*> prefixes;
  PathTrie *prefix_root;
};

#endif  // DECODERSTATE_H_
