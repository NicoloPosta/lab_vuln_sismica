function tester(img_size, path)
    files = dir(path + '*.bmp');
    for file = files'
        img = imread(path + file.name);
        if (size(img, 1) < img_size)
            method_names = {'nearest', 'bilinear', 'bicubic', 'lanczos2', 'lanczos3'};
            for i = 1:5
                result = phase_separation(img, false, true, method_names(i));
                name = file.name(1:end-4);
                name = path + name + "_phase_separation_" + method_names(i) + ".bmp";
                disp(name);
                imwrite(result, name);
            end
        else
            result = phase_separation(img, false);
            name = file.name(1:end-4);
            name = path + name + "_phase_separation.bmp";
            disp(name);
            imwrite(result, name);
        end
    end
end

