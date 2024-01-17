using eCinema.Core;
using Microsoft.AspNetCore.Http;

namespace eCinema.Application
{
    public class PhotoProfile : BaseProfile
    {
        public PhotoProfile()
        {
            CreateMap<PhotoDto, Photo>().ReverseMap();

            CreateMap<PhotoUpsertDto, Photo>();

            CreateMap<IFormFile, Photo>().ReverseMap();

            CreateMap<IFormFile, PhotoUpsertDto>().ReverseMap();
        }
    }
}
