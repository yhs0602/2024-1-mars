// Get Polylux from the official package repository
#import "@preview/polylux:0.3.1": *

// Make the paper dimensions fit for a presentation and the text larger
#set page(
  paper: "presentation-16-9",
  fill: rgb(255, 253, 235)
)
#set text(
	size: 25pt,
	font: "Pretendard",
)
#set list(spacing: 2em, tight: true)
#show heading: it => {
  it.body
  v(0.2em)
}
#let KL = math.op("KL")
#let Uniform = math.op("Uniform")
#let ReLU = math.op("ReLU")

// Use #polylux-slide to create a slide and style it using your favourite Typst functions
#polylux-slide[
  #align(horizon + center)[
    = Learning Fine-Grained Bimanual Manipulation with Low-Cost Hardware
    \ RSS 2023

    양현서

    July 12, 2024
  ]
]

#polylux-slide[
  ==  About

  - Author: Tony Z. Zhao, Vikash Kumar, Sergey Levine, Chelsea Finn

  - Conference: RSS 2023 
]

#polylux-slide[
  == Motivation
  #list(
    tight: false,
    [*Fine manipulation tasks* such as
      #list(
        tight: true,
        [threading cable ties],
        [slotting a battery],
      )
      #pause
    ],
    [*Requires*
      #list(
        tight: true,
        [precision],
        [careful coordination of contact forces],
        [closed-loop visual feedback],  
      )

    ]
  )
]

#polylux-slide[
  == Low cost and imprecise hardware for fine manipulation tasks
  #block(
  fill: color.purple.lighten(80%),
  inset: 20pt,
  radius: 20%,
  width: 100%,
  [
    #heading[Suggestion]
    #v(10pt)
     *Low-cost system* that performs end-to-end *imitation learning* directly from real demonstrations, collected with a custom teleoperation interface
  ]
  )
]

#polylux-slide[
  == Challenges in Imitation Learning
    #list(
    tight: false,
    [*Errors* in the policy can compound over time #pause],
    [Human demonstrations can be *non-stationary*]
  )
]

#polylux-slide[
  == Introduction
  #list(
    tight: true,
    [Fine manipulation tasks require *precision and coordination* #pause],
    [Current systems are *expensive and complex* #pause],
    [Goal: Develop a low-cost, effective system for bimanual manipulation #pause],
    [Key contributions:
      #list(
        tight: true,
        [Low-cost hardware setup],
        [Novel imitation learning algorithm (ACT)],
        [Successful demonstration on various tasks]
      )
    ]
  )
]

#polylux-slide[
  == System Design - Low-cost hardware
  #list(
    tight: false,
    [ViperX 6-DoF robot arms],
    [3D printed components],
    [Cost: <\$20k]
  )
]


#polylux-slide[
  == System Design - Design principles
  #list(
    tight: false,
    [Versatile],
    [User-friendly],
    [Repairable],
    [Easy-to-build]
  )  
]


#polylux-slide[
  == System Design - Design principles - Teleoperation setup
  #list(
    tight: false,
    [Joint-space mapping for control],
    [High-frequency control (50Hz)],
    [3D printed “see-through” fingers, gripping tape]
  )
]

#polylux-slide[
  == Joint space mapping for control
  - Directly maps "Leader" joint angles to "Follower" joint angles
  - Solves IK failing problem
  #figure(
     image("images/robots.png", width: 85%), 
  )
]

#polylux-slide[
  == Imitation Learning Algorithm
  #list(
    tight: false,
    [*Challenges*:
      #list(
        tight: true,
        [Compounding errors in policy],
        [Non-stationary human demonstrations]
      )
    ],
    [*Solution: Action Chunking with Transformers (ACT)*:
      #list(
        tight: true,
        [Predicts sequences of actions (chunks)],
        [Reduces effective horizon of tasks],
        [Uses temporal ensembling for smoothness]
      )
    ]
  )
]

#polylux-slide[
  == Training ACT on a New Task
  #list(
    tight: false,
    [Record leader joint positions as actions],
    [Observations: follower joint positions, 4 camera feeds],
    [Train ACT: predict future actions from observations],
    [Test: use policy with lowest validation loss],
    [*Challenge: Compounding errors*]
  )
]

#polylux-slide[
  == Action Chunking
  #list(
    tight: false,
    [*Groups individual actions into units* for efficient storage and execution],
    [Reduces the *effective horizon* of long trajectories],
    [Every $k$ steps, the agent receives an observation and generates $k$ actions],
    [Mitigates issues with non-stationary demonstrations]
  )
]

#polylux-slide[
  == Temporal Ensemble
  #list(
    tight: false,
    [Creates *overlapping action chunks*],
    [Queries the policy at *every step* for precise and smoother motions],
    [*Combines* predictions using a weighted average],
    [No additional training cost, only extra inference-time computation],
  )
]

#polylux-slide[
  == Modeling Human Data
  #list(
    tight: false,
    [Human demonstrations are *noisy and inconsistent* #pause],
    [*Different* trajectories can be used for the same observation #pause],
    [Human actions are more *stochastic* where precision matters less #pause],
    [Policy must *focus on high precision* areas]
  )
]

#polylux-slide[
  == Conditional Variational Autoencoder (CVAE)
  #list(
    tight: false,
    [Train action chunking policy as a generative model #pause],
    [Only decoder (policy) used in deployment #pause],
    [Maximize log-likelihood of demonstration action chunks],
  )
]

#polylux-slide[
  == Implementation of ACT: Encoder
  #list(
    tight: false,
    [CVAE encoder and decoder implemented with transformers],
    [BERT-like transformer encoder used],
    [Inputs: current joint positions and target action sequence],
    [Outputs: mean and variance of "style variable" $z$],
    [Encoder only used during training]
  )
]

#polylux-slide[
  == Implementation of ACT: Decoder
  #list(
    tight: false,
    [Predicts next $k$ actions],
    [Inputs: current observations and $z$],
    [Observations: 4 RGB images and joint positions of 2 robot arms],
    [ResNet18 used for image processing],
  )
]

#polylux-slide[
  == Implementation of ACT: Decoder
  #list(
    tight: false,
    [Transformer encoder synthesizes information],
    [Transformer decoder generates action sequence],
    [L1 loss used for precise action sequence modeling]
  )
]


#polylux-slide[
  == Experiment Tasks
  #list(
    tight: true,
    [Slide Ziploc: Grasp and open ziploc bag slider],
    [Slot Battery: Insert battery into remote controller slot],
    [Open Cup: Open lid of small condiment cup],
    [Thread Velcro: Insert velcro cable tie into loop],
    [Prep Tape: Cut and hang tape on box edge],
    [Put On Shoe: Put shoe on mannequin foot and secure velcro strap],
    [Transfer Cube (sim): Transfer red cube to other arm],
    [Bimanual Insertion (sim): Insert peg into socket in mid-air]
  )
]

#polylux-slide[
  == Challenges
  #list(
    tight: false,
    [Requires ine-grained bimanual control],
    [Perception challenges (e.g., transparency, low contrast)],
    [Random initial placement of objects],
    [Need for visual feedback to correct perturbations],
    [Precise manipulation needed]
  )
]

#polylux-slide[
  == Data Collection
  #list(
    tight: false,
    [Collected demonstrations using ALOHA teleoperation for 6 real-world tasks],
    [Each episode: 8-14 seconds (400-700 time steps at 50Hz)],
    [50 demonstrations per task (100 for Thread Velcro)],
    [Total: 10-20 minutes of data per task],
    [Two types of demonstrations for simulated tasks: scripted policy and human demonstrations],
    [Human demonstrations are stochastic:
      #list(
        tight: true,
        [Mid-air handover example: position varies each time],
        [Policy must learn dynamic adjustments, not memorization]
      )
    ]
  )
]
#polylux-slide[
  == Experiment Comparison
  #list(
    tight: false,
    [Compared ACT with four methods:
      #list(
        tight: true,
        [BC-ConvMLP: Simple baseline with convolutional network],
        [BeT: Uses Transformers, no action chunking, separate visual encoder],
        [RT-1: Transformer-based, predicts one action from history],
        [VINN: Non-parametric, uses k-nearest neighbors]
      )
    ],
    [ACT directly predicts continuous actions]
  )
]

#polylux-slide[
  == Experiment Results
  #list(
    tight: false,
    [ACT outperforms all prior methods in both simulated and real tasks],
    [Simulated tasks: ACT shows 20%-59% higher success rates],
    [Real-world tasks: Slide Ziploc (88%), Slot Battery (96%)],
    [ACT's performance in Thread Velcro was lower (20%) due to precision challenges]
  )
]
#polylux-slide[
  == Action Chunking and Temporal Ensembling
  #list(
    tight: false,
    [Action chunking reduces compounding errors by dividing sequences into chunks],
    [Performance improves with increasing chunk size, best at k = 100],
    [Temporal ensembling further improves performance by averaging predictions]
  )
]


#polylux-slide[
  == Training with CVAE
  #list(
    tight: false,
    [CVAE models noisy human demonstrations],
    [Essential for learning from human data, removing CVAE objective significantly drops performance],
    [Human data success rate drops from 35.3% to 2% without CVAE]
  )
]


#polylux-slide[
  == Is High-Frequency Necessary?
  #list(
    tight: false,
    [User study shows higher performance at 50Hz compared to 5Hz],
    [Tasks: threading zip cable tie and unstacking plastic cups],
    [50Hz: faster and more accurate task completion],
    [50Hz reduces teleoperation time by 62% compared to 5Hz]
  )
]

#polylux-slide[
  == Limitations and Conclusion
  #list(
    tight: false,
    [Presented a low-cost system for fine manipulation],
    [Components: ALOHA teleoperation system and ACT imitation learning algorithm],
    [Enables learning fine manipulation skills in real-world],
    [Examples: Opening a translucent condiment cup, slotting a battery (80-90% success rate, ~10 min demonstrations)],
    [Limitations: Tasks beyond current capabilities, e.g., buttoning a dress shirt],
    [Hope: Important step and accessible resource for advancing fine-grained robotic manipulation]
  )
]



#polylux-slide[
  == Experimental Results - Performance
  #list(
    tight: false,
    [Success rates of 80-90%],
    [Comparison with baselines:
      #list(
        tight: true,
        [ACT significantly outperforms other methods],
        [Effective in both simulated and real-world tasks]
      )
    ]
  )
]




#polylux-slide[
  == Conclusion and Future Work
  #list(
    tight: false,
    [*Conclusion*:
      #list(
        tight: true,
        [Developed a low-cost, effective system for fine manipulation],
        [Proposed a novel imitation learning algorithm (ACT)]
      )
    ],
    [*Future Work*:
      #list(
        tight: true,
        [Improving generalization to new tasks],
        [Enhancing hardware precision],
        [Exploring more complex manipulation tasks]
      )
    ]
  )
]


// #polylux-slide[
//   == Evaluation
//   #box(width: 100%, height: 87%,
//  columns(2, gutter: 0pt)[
//    #set par(justify: true)
//   //  #figure(
//   //   image("images/eval.png", width: 100%),
//   //  )
//    #colbreak()
//    - CLIPDraw _performed best_, but *qualitative results are poor*
//    - Therefore, also use OpenCLIP score
//    - Effect of rejection sampling $tilde$ caption consistency
//  ]
// )
//   #table(
//   columns:(auto, 1fr, 1fr), 
//   table.vline(x: 1, start: 0),
//   table.hline(y: 1, start: 0),
//   inset:(10pt),
//   fill:color.yellow.lighten(85%),
//   table.header[][Multimodal][Recurrent],
//  [kcc-husk-vision-dqn], [X], [X],
//  [kcc-husk-bimodal-dqn-final], [O], [X],
//  [kcc-husk-vision-drqn-final], [X], [O],
//  [kcc-husk-bimodal-drqn-final], [O], [O],
//)
// ]

// #polylux-slide[
//   == Qualitative Results
// //   #figure(
// //   image("images/results.png", width: 100%),
// // //   #table(
// // //   columns:(auto, 1fr, 1fr), 
// // //   table.vline(x: 1, start: 0),
// // //   table.hline(y: 1, start: 0),
// // //   inset:(10pt),
// // //   fill:color.yellow.lighten(85%),
// // //   table.header[][Multimodal][Recurrent],
// // //  [kcc-husk-vision-dqn], [X], [X],
// // //  [kcc-husk-bimodal-dqn-final], [O], [X],
// // //  [kcc-husk-vision-drqn-final], [X], [O],
// // //  [kcc-husk-bimodal-drqn-final], [O], [O],
// // )
// ]

// #polylux-slide[
//   == Discussion
//   - Utilizes pretrained diffusion models *without captioned SVG datasets*
//   - Effectively shows the *distillation of generative models* compared to contrastive models #pause
//   \
//   - Computationally more *expensive* than CLIP-based approaches
//   - *Limited* by the quality and biases of the pretrained diffusion model
// ]

// #polylux-slide[
//   == References
//   - DiffVG
//   - LIVE
//   - VectorFusion
// ]