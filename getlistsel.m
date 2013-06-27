function out=getlistsel(listhandle)
contents=get(listhandle,'String');
list=get(listhandle,'Value');
out=contents{list};
end