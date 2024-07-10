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
    = VectorFusion: Text-to-SVG by Abstracting Pixel-Based Diffusion Models
    \ CVPR 2023

    양현서

    May 31, 2024
  ]
]

#polylux-slide[
  ==  About

  - Author: Ajay Jain, Amber Xie, and Pieter Abbeel from UC Berkeley

  - Conference: CVPR 2023 
]

#polylux-slide[
  == Motivation
  #list(
    tight: false,
    [Diffusion models well generate high-quality *rasterized* images #pause],
    [However, designers also vastly use *vectorized* images in practice like SVG (Scalable Vector Graphics) #pause],
    [Training diffusion model to generate vectorized images is theoritically possible but practically challenging],
  )
]

#polylux-slide[
  == Challenges of training diffusion models for vectorized images
  #list(
    tight: false,
    [Most labeled datasets are for rasterized images #pause],
    [Vectorized images' data structure is more complex (hierarchical and variable-lengthed) than rasterized images']
  )

]

#polylux-slide[
  == Baselines
  #enum(
    tight: false,
    [Generate a rasterized image with a pretrained diffusion model#pause],
    [Convert the rasterized image to a vectorized image using a vectorization algorithm: *LIVE algorithm*]
  )
  #pause
  #block(
  fill: color.purple.lighten(80%),
  inset: 20pt,
  radius: 20%,
  width: 100%,
  [
    #heading[Challenges]
    #v(10pt)
    - Diffusion Models often generate *too complex* rasterized images to be vectorized
    - Automated conversion *loses details*
  ]
  )
]

#polylux-slide[
  == VectorFusion
  #list(
    tight: false,
    [Differentiable vector graphics renderer #pause],
    [Score Distillation Sampling #pause],
    [SVG-Specific regularization]
  )
]

#polylux-slide[
  == Background: Vector representation and rendering pipeline
  ```svg
    <svg width="200" height="200" xmlns="http://www.w3.org/2000/svg">
      <circle cx="50" cy="50" r="40" stroke="black" stroke-width="3" fill="red" />
    </svg> 
  ```
  #pause
  #set align(center)
  #image.decode(
    "<svg width=\"100\" height=\"100\" xmlns=\"http://www.w3.org/2000/svg\"> <circle cx=\"50\" cy=\"50\" r=\"40\" stroke=\"black\" stroke-width=\"3\" fill=\"red\" /></svg>")
]

#polylux-slide[
  == Background: SVG Path
  - #text([`M x,y`: Move to the point (x, y)], fill: color.blue, weight: 700)
  - `L x,y`: Draw a line to the point (x, y)
  - `H x`: Draw a horizontal line to x
  - `V y`: Draw a vertical line to y
  - #text([`C x1, y1, x2, y2, x, y`: Draw a cubic Bezier curve], fill: color.blue, weight: 700)
  - `Q x1, y1, x, y`: Draw a quadratic Bezier curve
  - #text([`Z`: Close the path], fill: color.blue, weight: 700)
]

#polylux-slide[
  == Background: SVG Path
  ```svg
    <svg width="200" height="200" xmlns="http://www.w3.org/2000/svg">
      <path d="M10 80 C 40 10, 160 10, 190 80" stroke="black" fill="transparent"/>
    </svg> 
  ```
  #pause
  #set align(center)
  #image.decode(
    "<svg width=\"100\" height=\"100\" xmlns=\"http://www.w3.org/2000/svg\"><path d=\"M10 80 C 40 10, 160 10, 190 80\" stroke=\"black\" fill=\"transparent\"/></svg>"
  )
]

#polylux-slide[
  == Vector Grapchic Parameterization
  #box(width: 100%, height: 87%,
 columns(2, gutter: 0pt)[
   #set par(justify: true)
   #figure(
    image("images/svg_param.png", height: 100%),
   )
   #colbreak()
   - $s$: number of segments
   - $n$: number of paths to add
   #figure(
    image("images/gradient.svg", height: 100%),
   )
 ]
)
]

#polylux-slide[
  == Background: Diffusion Models Training
  - $cal(L)_("DDPM")(phi.alt, mono(x)) = EE_(t, epsilon.alt) [w(t)||epsilon.alt_phi.alt (alpha_t mono(x) + sigma_t epsilon.alt) - epsilon.alt||^2_2]$ #footnote([$alpha_t = sqrt(1-beta_t)$, $sigma_t = sqrt(beta_t)$]) #pause
  #place(
    top + left,
    dx: 243pt,
    dy: 30pt,
    rect(
      stroke: color.red + 3pt,
      radius: 40%,
      height: 50pt,
      width: 47pt,
    )
  )

  - #text([$w(t)$: Sampling weight (usually evenly set to 1) #pause], fill: color.red )
  #place(
    top + left,
    dx: 299pt,
    dy: 30pt,
    rect(
      stroke: color.blue + 3pt,
      radius: 40%,
      height: 50pt,
      width: 24pt,
    )
  )
  - #text([$epsilon.alt_phi.alt$: Noise Prediction Model #pause], fill: color.blue )
  #place(
    top + left,
    dx: 356pt,
    dy: 30pt,
    rect(
      stroke: color.green + 3pt,
      radius: 40%,
      height: 50pt,
      width: 18pt,
    )
  )
  #place(
    top + left,
    dx: 134pt,
    dy: 30pt,
    rect(
      stroke: color.green + 3pt,
      radius: 40%,
      height: 50pt,
      width: 18pt,
    )
  )
  - #text([$mono(x)$: Original data sample #pause], fill: color.green )
  #place(
    top + left,
    dx: 424pt,
    dy: 30pt,
    rect(
      stroke: color.purple + 3pt,
      radius: 40%,
      height: 50pt,
      width: 12pt,
    )
  )
  #place(
    top + left,
    dx: 474pt,
    dy: 30pt,
    rect(
      stroke: color.purple + 3pt,
      radius: 40%,
      height: 50pt,
      width: 12pt,
    )
  )
  - #text([$epsilon.alt$: Random (Gaussian) noise  #pause], fill: color.purple )

#place(
    top + left,
    dx: 330pt,
    dy: 30pt,
    rect(
      stroke: color.orange + 3pt,
      radius: 40%,
      height: 50pt,
      width: 28pt,
    )
  )
  #place(
    top + left,
    dx: 400pt,
    dy: 30pt,
    rect(
      stroke: color.orange + 3pt,
      radius: 40%,
      height: 50pt,
      width: 25pt,
    )
  )
  - #text([$alpha_t$, $sigma_t$: Propotion of $mono(x)$ and $epsilon.alt$], fill: color.orange)

]

#polylux-slide[
  == Background: Diffusion Models Sampling
  + Sample $mono(x)_t$ from a prior.
  + Predict noise $epsilon.alt_phi.alt (mono(x)_t)$.
  + Compute $hat(mono(x))$.

    $hat(mono(x)) &= (mono(x)_t - sigma_t epsilon.alt_phi.alt (mono(x)_t))/alpha_t$

  + Compute $mono(x)_(t-1)$ and feed to the next step.
    
    $mono(x)_(t-1) = alpha_(t-1)hat(mono(x))+sigma_(t-1)epsilon.alt_phi.alt (mono(x)_t)$
]

#polylux-slide[
  == Background: Classifier Free Guidance
  $hat(epsilon.alt)_phi.alt (mono(x), y) = (1 + omega) * epsilon.alt_phi.alt (mono(x), y) - omega * epsilon.alt_phi.alt (mono(x))$

  #list(
    tight: false,
    [Generate both conditional and unconditional prediction for the noise. $epsilon.alt_phi.alt (mono(x), y)$ and $epsilon.alt_phi.alt (mono(x))$ #pause],
    [Combine them with a weight $omega$ #pause],
    [This enhances the model's ability to generate images with the desired class.]
  )
]

#polylux-slide[
  == Score Distillation Sampling
  $cal(L)_("SDS") = EE_(t, epsilon.alt) [sigma_t / alpha_t w(t) KL(q(mono(x)_t|g(theta);y, t)|| p_phi.alt (mono(x)_t; y, t))]$ #pause
  - $p_phi.alt$ is a *frozen* noise prediction model
  - $q$ is a unimodal gaussian centered at a learned image $g(theta)$
  - The larger $sigma_t / alpha_t$, the more the model prediction is important
  #pause
  $nabla_theta cal(L)_"SDS" = EE_(t, epsilon.alt) [w(t) (hat(epsilon.alt)_t (mono(x)_t; y, t) - epsilon.alt)(partial mono(x))/(partial theta) ]$
]

#polylux-slide[
  #set align(center+horizon)
  == Method
]

#polylux-slide[
  == Baseline
  + Sample an image using a pretrained diffusion model. #pause
  + Automatically convert the image to an SVG using the LIVE algorithm. #pause
  #block(
  fill: color.purple.lighten(80%),
  inset: 15pt,
  radius: 20%,
  width: 100%,
  [
    Provide "minimal flat 2d vector icon. lineal color. on a white background. trending on artstation" as a prompt.
  ]
  )
  #pause
  #block(
  fill: color.orange.lighten(80%),
  inset: 15pt,
  radius: 20%,
  width: 100%,
  [
    *Rejection Sampling*\
    Sample $K=4$ images, select best by CLIP ViT-B/16 score
  ]
  )
]

#polylux-slide[
  == VectorFusion
  + Initialize a parameter ${p_1, p_2, ..., p_k}$ #pause
  + Repeat the following: #pause
    + DiffVg renders a 600 #sym.times 600 image using the parameters #pause
    + Augment the image (perspective transformation, 512 #sym.times 512 crop) #pause
    + Map the image to the latent space #pause
    + Compute $mono(z)_t = alpha_t mono(z) + sigma_t epsilon.alt$ #pause
    + Remove the noise using the noise prediction model #pause
    + Update the parameters using SDS loss
]

#polylux-slide[
  == VectorFusion: Details
  - Sample $t$ from $t tilde.basic Uniform(50, 950)$
  - Use fp16 precision
    - Use fp32 precision for $(partial mono(z)) / (partial mono(x)_"aug")$ for stability
  - Apply self intersection regularizer loss also #footnote([$D_1=II(arrow(A B)dot arrow(B C))$, $D_2 = (arrow(A B) dot arrow(C D))/(||arrow(A B)||||arrow(C D)||)$])
    $
    cal(L)_"Xing" = D_1 (ReLU(-D_2) + (1-D_1)(ReLU(D_2)))
    $
  - Reinitialize low opacity or shrinked paths
]


#polylux-slide[
  == VectorFusion: Architecture
  #figure(
  image("images/architecture.png", width: 100%),
  caption: [
    VectorFusion architecture
  ]
)
]

#polylux-slide[
  == Evaluation
  #block(
  fill: color.orange.lighten(80%),
  inset: 15pt,
  radius: 20%,
  width: 100%,
  [
    *No test dataset available for vector graphics*\
    Therefore, use CLIP as an evaluation metric
  ]
  )
  #pause
  #block(
  fill: color.purple.lighten(80%),
  inset: 15pt,
  radius: 20%,
  width: 100%,
  [
    *R-Precision*\
    For 128 SVGs, assign the captions by the CLIP score and check if it was the correct caption. Get the fraction of correct captions.
  ]
  ) 
  #pause
  - Used rejection sampling ($K$ in the table)
]

#polylux-slide[
  == Evaluation
  #box(width: 100%, height: 87%,
 columns(2, gutter: 0pt)[
   #set par(justify: true)
   #figure(
    image("images/eval.png", width: 100%),
   )
   #colbreak()
   - CLIPDraw _performed best_, but *qualitative results are poor*
   - Therefore, also use OpenCLIP score
   - Effect of rejection sampling $tilde$ caption consistency
 ]
)
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
]

#polylux-slide[
  == Qualitative Results
  #figure(
  image("images/results.png", width: 100%),
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
)
]

#polylux-slide[
  == Discussion
  - Utilizes pretrained diffusion models *without captioned SVG datasets*
  - Effectively shows the *distillation of generative models* compared to contrastive models #pause
  \
  - Computationally more *expensive* than CLIP-based approaches
  - *Limited* by the quality and biases of the pretrained diffusion model
]

#polylux-slide[
  == References
  - DiffVG
  - LIVE
  - VectorFusion
]