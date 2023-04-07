using eCinema.Core;

namespace eCinema.Application
{
    public class PhotoProfile : BaseProfile
    {
        public PhotoProfile()
        {
            CreateMap<PhotoDto, Photo>().ReverseMap();

            CreateMap<PhotoUpsertDto, Photo>();
        }
    }
}
