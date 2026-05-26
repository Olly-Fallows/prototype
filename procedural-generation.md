# Types
- BSP (Binary Space Partioning)
- Cellular Automata
- Random Walk Dungeon Growing
- Wave Function Collapse
- Grammar-Based Dungeon Generation
- Room Graph
- Diamond Square Height Map

# BSP
BSP is super straightforward method of procedural generation, A basic method could follow the instructions below
1. Define area
2. Define number of rooms
4. Randomly generate binary tree so that bottem level of nodes is equal to number of rooms
5. traverse binary tree dividing the space as you go down the tree
6. each node now represents a room in the space
7. add corridor between each pair of rooms as show on the tree
8. basic structure is now generated

## Potential Improvements
- Drop the binary and have spaces partitioned by random number each step of tree
- Have a low number of rooms, but each room's contents is genrated by a different method creating variety
- Use random walk to create the corridors

# Cellular Automata
Uses a set of rules to turn noise into a clean structure
A basic method is applying conway's game of life to random noise
1. Start with noise at the desired size
2. Apply conway's rules with a threshold of 4
3. repeat 2 for a set number of iterations
4. detect seperate regions
5. carve tunnels between seperate regions

## Potential Improvments
- Use BSP to create a basic structure that is filled out with cellular automata

# Random Walk
Simplest possible procedural generation
1. Define the size of space
2. spawn a number of "agents" at a random position
3. everywhere agents are standing is set to floor
4. for each agent, move 1 square in on of 4 directions
5. repeat [3,4] until map is at desired density

## Potential Improvements
- Add additional actions to agents
    - Create a room
    - place locked doors/keys
    - etc
- Add attractors and repellors for agents to manipulate generation

# Wave Function Collapse


# Grammar-Base Dungeon
Add "Graph Grammars" to to existing level graph to add level beats such at locks and keys to make more "planned" dungeons opposed to spaces.

# Room Graph

# Diamond Square Height Map

