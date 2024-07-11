// Get Polylux from the official package repository
#import "@preview/polylux:0.3.1": *

// Make the paper dimensions fit for a presentation and the text larger
#set page(
  paper: "presentation-16-9",
  fill: rgb(235, 253, 255)
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
        [closed-loop visual feedback]  
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
  == Introduction
  #list(
    tight: true,
    [Fine manipulation tasks require *precision and coordination* #pause],
    [Current systems are *expensive and complex* #pause],
    [Goal: Develop a low-cost, effective system for bimanual manipulation #pause],
    [Key contributions:
      #list(
        tight: true,
        [*Low-cost* hardware setup],
        [Novel imitation learning algorithm *(ACT)*],
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
    [3D printed “see-through” fingers, gripping tape],
    [*Cost: <\$20k*]
  )
]


#polylux-slide[
  == System Design - Design principles
  #list(
    tight: false,
    [Versatile #pause],
    [User-friendly #pause],
    [Repairable #pause],
    [Easy-to-build]
  )  
]


#polylux-slide[
  == System Design - Design principles - Teleoperation setup
  #list(
    tight: false,
    [Joint-space mapping for control],
    [High-frequency control (50Hz)],
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
  #pause
  #list(
    tight: false,
    [*Challenges*:
      #list(
        tight: true,
        [Compounding errors in policy],
        [Non-stationary human demonstrations]
      ) #pause
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
    [Record leader joint positions as actions #pause],
    [Observations: follower joint positions, 4 camera feeds #pause],
    [Train ACT: predict future actions from observations #pause],
    [Test: use policy with lowest validation loss #pause],
    [*Challenge: Compounding errors*]
  )
]

#polylux-slide[
  == Action Chunking
  #list(
    tight: false,
    [*Groups individual actions into units* for efficient storage and execution #pause],
    [Reduces the *effective horizon* of long trajectories #pause],
    [Every $k$ steps, the agent receives an observation and generates $k$ actions #pause],
    [Mitigates issues with non-stationary demonstrations]
  )
]

#polylux-slide[
  == Action Chunking
  #figure(
    image("images/chunk.png", width: 70%),
  )
]

#polylux-slide[
  == Temporal Ensemble
  #list(
    tight: false,
    [Creates *overlapping action chunks* #pause],
    [Queries the policy at *every step* for precise and smoother motions #pause],
    [*Combines* predictions using a weighted average #pause],
    [No additional training cost, only extra inference-time computation],
  )
]

#polylux-slide[
  == Temporal Ensemble
  #figure(
    image("images/chunk.png", width: 70%),
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
  == Architecture
  #figure(
    image("images/arch.png", width: 110%),
  )
]

#polylux-slide[
  == Implementation of ACT: Encoder
  #list(
    tight: false,
    [CVAE encoder and decoder implemented with *transformers* #pause],
    [*BERT-like transformer* encoder used #pause],
    [Inputs: current joint positions and target action sequence #pause],
    [Outputs: mean and variance of "style variable" $z$ #pause],
    [Only used during training - $z$ set to 0 during test]
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
    [_Transformer_ encoder synthesizes information],
    [_Transformer_ decoder generates action sequence],
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
    [Requires fine-grained bimanual control #pause],
    [Perception challenges (e.g., transparency, low contrast) #pause],
    [Random initial placement of objects #pause],
    [Need for visual feedback to correct perturbations #pause],
    [Precise manipulation needed]
  )
]

#polylux-slide[
  == Data Collection
  #list(
    tight: false,
    [Collected using ALOHA teleoperation for 6 real-world tasks #pause],
    [Each episode: 8-14 seconds (400-700 time steps at 50Hz) #pause],
    [50 demonstrations per task (100 for Thread Velcro) #pause],
    [Total: 10-20 minutes of data per task #pause],
    [Scripted policy / human demonstrations for simulated tasks],
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
      ) #pause
    ],
    [ACT directly predicts continuous actions]
  )
]

#polylux-slide[
  == Experiment Results
  #pause
  #list(
    tight: false,
    [ACT outperforms all prior methods in both simulated and real tasks #pause],
    [Simulated tasks: ACT shows 20%-59% higher success rates #pause],
    [Real-world tasks: Slide Ziploc (88%), Slot Battery (96%) #pause],
    [ACT's performance in Thread Velcro was lower (20%) due to precision challenges]
  )
]
#polylux-slide[
  == Ablation: Action Chunking and Temporal Ensembling
  #list(
    tight: false,
    [Action chunking reduces compounding errors by dividing sequences into chunks],
    [Performance improves with increasing chunk size, best at k = 100],
    [Temporal ensembling further improves performance by averaging predictions]
  )
]


#polylux-slide[
  == Ablation: Training with CVAE
  #list(
    tight: false,
    [CVAE models noisy human demonstrations],
    [Essential for learning from human data, removing CVAE objective significantly drops performance #pause],
    [Human data success rate drops from 35.3% to 2% without CVAE]
  )
]


#polylux-slide[
  == Ablation: Is High-Frequency Necessary?
  #list(
    tight: false,
    [Human shows higher performance at 50Hz compared to 5Hz #pause],
    [Tasks: threading zip cable tie and unstacking plastic cups #pause],
    [50Hz: faster and more accurate task completion #pause],
    [50Hz reduces teleoperation time by 62% compared to 5Hz]
  )
]

#polylux-slide[
  == Ablation graphs
  #figure(
    image("images/abl.png", width: 100%),
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



// #polylux-slide[
//   == Experimental Results - Performance
//   #list(
//     tight: false,
//     [Success rates of 80-90%],
//     [Comparison with baselines:
//       #list(
//         tight: true,
//         [ACT significantly outperforms other methods],
//         [Effective in both simulated and real-world tasks]
//       )
//     ]
//   )
// ]




// #polylux-slide[
//   == Conclusion and Future Work
//   #list(
//     tight: false,
//     [*Conclusion*:
//       #list(
//         tight: true,
//         [Developed a low-cost, effective system for fine manipulation],
//         [Proposed a novel imitation learning algorithm (ACT)]
//       )
//     ],
//     [*Future Work*:
//       #list(
//         tight: true,
//         [Improving generalization to new tasks],
//         [Enhancing hardware precision],
//         [Exploring more complex manipulation tasks]
//       )
//     ]
//   )
// ]


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