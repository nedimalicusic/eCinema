using eCinema.Core;

namespace eCinema.Application
{
    public class GenreProfile : BaseProfile
    {
        public GenreProfile()
        {
            CreateMap<GenreDto, Genre>().ReverseMap();

            CreateMap<GenreUpsertDto, Genre>();
        }
    }
}
