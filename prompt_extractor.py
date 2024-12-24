from sd_parsers import ParserManager
import os
import glob

base_path = os.path.join(os.environ.get('USERPROFILE'),'PromptExtractor')
base_data_path = os.path.join(base_path,'data')

prompts_in_html_format_file_path = os.path.join(base_data_path,'prompts_history_data.html')
prompts_only_file_path = os.path.join(base_data_path,'prompts_history_data.txt')
images_base_path = os.path.join(base_data_path,'pics')

all_images = glob.glob(os.path.join(images_base_path, '**', '*.png'), recursive=True)
all_images += glob.glob(os.path.join(images_base_path, '**', '*.PNG'), recursive=True)
all_images += glob.glob(os.path.join(images_base_path, '**', '*.jpg'), recursive=True)
all_images += glob.glob(os.path.join(images_base_path, '**', '*.JPG'), recursive=True)
all_images += glob.glob(os.path.join(images_base_path, '**', '*.jpeg'), recursive=True)
all_images += glob.glob(os.path.join(images_base_path, '**', '*.JPEG'), recursive=True)

parser_manager = ParserManager()
html_output = "<html><head><link href=\"style.css\" rel=\"stylesheet\" type=\"text/css\" /></head><body><table>\n"
html_output += "<tr><th>Image</th><th>Prompts</th></tr>\n"
plain_output = ""

for image in all_images:
    image_path = image.replace('\\','/')
    try:
        prompt_info = parser_manager.parse(image_path)
    except:
        continue
    if prompt_info:
        print(prompt_info)
        if not prompt_info.prompts == "" and not prompt_info.prompts == []:
            prompt = prompt_info.prompts[0].value
        #print(negative_prompt)
        parameters = prompt_info.samplers
        if not parameters == "" and not parameters == []:
            sampler = parameters[0].name
            steps = parameters[0].parameters['steps']
            cfg_scale = parameters[0].parameters['cfg_scale']
            seed = parameters[0].parameters['seed']
            settings = f"<p>Sampler: {sampler}<br>Steps: {steps}<br>CFG Scale: {cfg_scale}<br>Seed: {seed}</p>"
        #print(settings)
        html_output += f"<tr><td class=\"picture\"><img src='{image_path}' alt='Image' style='width:256px;'>{settings}</td><td class=\"prompt\"><strong style=\"color:dodgerblue\">Prompt:</strong><p>{prompt}</p></td></tr>\n"
        plain_output += str(str(str(prompt).replace('\n',''))+'\n')
html_output += "</table></body></html>"

with open(prompts_in_html_format_file_path, 'w', encoding="utf-8") as file:
    file.write(html_output)
with open(prompts_only_file_path, 'w', encoding="utf-8") as file:
    file.write(plain_output)