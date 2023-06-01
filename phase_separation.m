function result=phase_separation(img, inverted, half_yes, method_name)
    %trasformo l'immagine in grayscale se non lo è
    if (ndims(img)) > 2
        img = rgb2gray(img);
    end

    if nargin < 2 || isempty(inverted)
        inverted = false;
    end

    if nargin < 3 || isempty(half_yes)
        half_yes = false;
    end

    if nargin < 3 || isempty(method_name)
        method_name = 'nearest';
    end

    
    if (half_yes) &&  not(isempty(method_name))
        if(strcmp(method_name, 'nearest'))
            img=imresize(img,2,'nearest');
        elseif(strcmp(method_name, 'bilinear'))
            img=imresize(img,2,'bilinear');
        elseif(strcmp(method_name, 'bicubic'))
            img=imresize(img,2,'bicubic');
        elseif(strcmp(method_name, 'lanczos2'))
            img=imresize(img,2,'lanczos2');
        elseif(strcmp(method_name, 'lanczos3'))
            img=imresize(img,2,'lanczos3');
        end
    end


    %filtro mediano
    img = medfilt2(img);

    %incremento contrasto immagine
    max_value=max(img(:));
    min_value=min(img(:));
    img = imadjust(img, [min_value/255 max_value/255], [0.0 1.0]);

    img=not(adaptivethreshold(img,floor(size(img,1)/6), 0.0, 0));
       
    %rimozione buchi
    [N, M] = size(img);
    img_tmp = zeros(N+4, M+4);
    img_tmp(3:N+2,3:M+2) = img;
    img_tmp_filled = imfill(img_tmp, 'holes');
    img = img_tmp_filled(3:N+2, 3:M+2);
    
    if (inverted)
        %erosione
        img=imerode(img, strel('square',3));
        %dilatazione
        img=imdilate(img,strel('square',3));
    else
        %dilatazione
        img=imdilate(img,strel('square',3));
        %erosione
        img=imerode(img, strel('square',3));
    end
    
    % imshow(img);
    result=img;

end
