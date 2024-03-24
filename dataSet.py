!pip install --upgrade diffusers[torch]
!pip install transformers

from diffusers import DiffusionPipeline
import torch

pipeline = DiffusionPipeline.from_pretrained("runwayml/stable-diffusion-v1-5", torch_dtype=torch.float16)
pipeline.to("cuda")


### generate images ###

import random
import os


#Beofre you satrt make sure if you want all the data set or just sad/angry 

import matplotlib.pyplot as plt

os.makedirs('/content/faces/neutral', exist_ok=True)
os.makedirs('/content/faces/happy', exist_ok=True)
os.makedirs('/content/faces/sad', exist_ok=True)
os.makedirs('/content/faces/angry', exist_ok=True)


ethnicities = ['an african american ', 'a white', 'an african', 'a south asian', 'a east asian', 'a middle east']

genders = ['male', 'female']

emotion_prompts = {'neutral':'closed mouth, stright face',
                  'happy': 'smiling',
                   'sad': 'frowning, sad face expression',
                   'angry': 'angry'}


for j in range(2):

  for emotion in emotion_prompts.keys():

    emotion_prompt = emotion_prompts[emotion]

    ethnicity = random.choice(ethnicities)
    gender = random.choice(genders)

    #print(emotion, ethnicity, gender)

    prompt = 'Medium-shot portrait of {} {}, {}, front view, looking at the camera, color photography, '.format(ethnicity, gender, emotion_prompt) + \
            'photorealistic, hyperrealistic, realistic, incredibly detailed, crisp focus, digital art, depth of field, 50mm, 8k'
    negative_prompt = '3d, cartoon, anime, sketches, (worst quality:2), (low quality:2), (normal quality:2), lowres, normal quality, ((monochrome)), ' + \
                      '((grayscale)) Low Quality, Worst Quality, plastic, fake, disfigured, deformed, blurry, bad anatomy, blurred, watermark, grainy, signature'

    img = pipeline(prompt, negative_prompt=negative_prompt).images[0]

    img.save('/content/faces/{}/{}.png'.format(emotion, str(j).zfill(4)))

    #plt.imshow(img)
    #plt.show()
