using eCinema.Core;

namespace eCinema.Application
{
    public class MovieActorProfile : BaseProfile
    {
        public MovieActorProfile()
        {
            CreateMap<MovieActorsDto, MovieActors>().ReverseMap();

            CreateMap<MovieActorsUpsertDto, MovieActors>();
        }
    }
}
